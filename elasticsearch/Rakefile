desc "Create a release tag and push everything to Github"
task :release do
  unless `git status --porcelain`.to_s =~ /^\s*$/
    puts "[!] Error, repository dirty, please commit or stash your changes.", ""
    exit(1)
  end
  if version = File.read('metadata.rb')[/^version\s*"(.*)"$/, 1]
    sh <<-COMMAND.gsub(/      /, ' ')
      git tag #{version} && \
      git push origin master --verbose && \
      git push origin --tags --verbose && \
      knife cookbook site share "elasticsearch" "Databases"
    COMMAND
  end
end

require 'json'
require 'fog'
require 'ansi'

module Provision

  class Server
    attr_reader :name, :options, :node, :ui

    def initialize(options = {})
      @options   = options
      @name      = @options.delete(:name)
    end

    def create!
      create_node
      tag_node
      msg "Waiting for SSH...", :yellow
      wait_for_sshd and puts
    end

    def destroy!
      servers = connection.servers.select { |s| s.tags["Name"] == name && s.state != 'terminated' }
      if servers.empty?
        msg "[!] No instance named '#{name}' found!", :red
        exit(1)
      end

      puts "Will terminate #{servers.size} server(s): ",
           servers.map { |s| "* #{s.tags["Name"]} (#{s.id})" }.join("\n"),
           "Continue? (y/n)"

      exit(0) unless STDIN.gets.strip.downcase == 'y'

      servers.each do |s|
        @node = s
        msg "Terminating #{node.tags["Name"]} (#{node.id})...", :yellow
        connection.terminate_instances(node.id)
        msg "Done.", :green
      end
    end

    def connection
      @connection ||= Fog::Compute.new(
          :provider              => 'AWS',
          :aws_access_key_id     => options[:aws_access_key_id],
          :aws_secret_access_key => options[:aws_secret_access_key],
          :region                => options[:aws_region]
      )
    end

    def node
      @node ||= connection.servers.select { |s| s.tags["Name"] == name && s.state != 'terminated' }.first
    end

    def create_node
      msg "Creating EC2 instance #{name} in #{options[:aws_region]}...", :bold
      msg "-"*ANSI::Terminal.terminal_width


      server_options = {:image_id   => options[:aws_image],
                        :groups     => options[:aws_groups].split(",").map {|x| x.strip},
                        :flavor_id  => options[:aws_flavor],
                        :key_name   => options[:aws_ssh_key_id],
                        :block_device_mapping => options[:block_device_mapping] || [ { "DeviceName" => "/dev/sde1", "VirtualName" => "ephemeral0" }]}

      server_options.update :iam_instance_profile_name => options[:iam_profile] if options[:iam_profile]

      @node = connection.servers.create(server_options)

      msg_pair "Instance ID",       node.id
      msg_pair "Flavor",            node.flavor_id
      msg_pair "Image",             node.image_id
      msg_pair "Region",            options[:aws_region]
      msg_pair "Availability Zone", node.availability_zone
      msg_pair "Security Groups",   node.groups.join(", ")
      msg_pair "SSH Key",           node.key_name

      msg "Waiting for instance...", :yellow
      @node.wait_for { print "."; ready? }
      puts

      msg_pair "Public DNS Name",    node.dns_name
      msg_pair "Public IP Address",  node.public_ip_address
      msg_pair "Private DNS Name",   node.private_dns_name
      msg_pair "Private IP Address", node.private_ip_address
    end

    def tag_node
      msg "Tagging instance in EC2...", :yellow

      custom_tags  = options[:tags].split(",").map {|x| x.strip} rescue []

      tags         = Hash[*custom_tags]
      tags["Name"] = @name

      tags.each_pair do |key, value|
        connection.tags.create :key => key, :value => value, :resource_id => @node.id
        msg_pair key, value
      end
    end

    def wait_for_sshd
      hostname = node.dns_name
      loop do
        begin
          print(".")
          tcp_socket = TCPSocket.new(hostname, 22)
          readable = IO.select([tcp_socket], nil, nil, 5)
          if readable
            msg "\nSSHd accepting connections on #{hostname}, banner is: #{tcp_socket.gets}", :green
            return true
          end
        rescue SocketError
          sleep 2
          retry
        rescue Errno::ETIMEDOUT
          sleep 2
          retry
        rescue Errno::EPERM
          return false
        rescue Errno::ECONNREFUSED
          sleep 2
          retry
        rescue Errno::EHOSTUNREACH
          sleep 2
          retry
        ensure
          tcp_socket && tcp_socket.close
        end
      end
    end

    def ssh(command)
      host = node.dns_name
      user = options[:ssh_user]
      key  = options[:ssh_key]
      opts = "-o User=#{user} -o IdentityFile=#{key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

      __command = "ssh -t #{opts} #{host} '#{command}'"
      # puts   __command
      system __command
    end

    def scp(files, params={})
      host = node.dns_name
      user = options[:ssh_user]
      key  = options[:ssh_key]
      opts = "-o User=#{user} -o IdentityFile=#{key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r"
      path = params[:path] || '/tmp'

      __command = "scp #{opts} #{files} #{host}:#{path}"
      puts   __command
      system __command
    end

    def msg message, color=:white
      puts message.ansi(color)
    end

    def msg_pair label, value, color=:cyan
      puts (label.to_s.ljust(25) + value.to_s).ansi(color)
    end

  end

end

desc "Create, bootstrap and configure an instance in EC2"
task :create => :setup do
  @server = Provision::Server.new @args

  @server.create!

  Rake::Task[:upload].execute
  Rake::Task[:bootstrap].execute
  Rake::Task[:provision].execute
end

desc "Terminate an EC2 instance"
task :destroy => :setup do
  @server = Provision::Server.new @args
  @server.destroy!
end

task :upload => :setup do
  system "tar -zcf ./tmp/cookbook-elasticsearch.tar.gz --exclude='.git,.vagrant,tmp,test,tests' ."

  @server ||= Provision::Server.new @args
  @server.scp './tmp/node.json ./tmp/cookbook-elasticsearch.tar.gz', :path => '/tmp'
  @server.ssh 'sudo mkdir -p /tmp/cookbooks/elasticsearch && sudo tar -zxf /tmp/cookbook-elasticsearch.tar.gz -C /tmp/cookbooks/elasticsearch'
  exit(1) unless $?.success?
end

desc "Bootstrap an instance"
task :bootstrap => :setup do
  @server ||= Provision::Server.new @args

  @server.ssh <<-COMMAND
    sudo apt-get update --yes --fix-missing;
    sudo apt-get install build-essential --yes --fix-missing;
    sudo apt-get install vim screen curl git-core --yes --fix-missing;

    test -d "/opt/chef" || curl -# -L http://www.opscode.com/chef/install.sh | sudo bash -s --;

    sudo apt-get install libyaml-dev libxml2-dev libxslt-dev libssl-dev --yes --fix-missing;
    sudo /opt/chef/embedded/bin/gem install berkshelf --version 1.4.5 --no-rdoc --no-ri

    sudo mkdir -p /etc/chef/;
    sudo mkdir -p /var/chef/site-cookbooks;
    sudo mkdir -p /var/chef/cookbooks;

    if [ -f /tmp/solo.rb ]  ; then sudo mv /tmp/solo.rb /etc/chef/solo.rb; fi
    if [ -f /tmp/node.json ]; then sudo mv /tmp/node.json /etc/chef/node.json; fi
    if [ -d /tmp/cookbooks ]; then sudo cp -r /tmp/cookbooks/* /var/chef/cookbooks/; fi

    sudo /opt/chef/embedded/bin/berks install --path=/var/chef/cookbooks/ --berksfile=/var/chef/cookbooks/elasticsearch/Berksfile
  COMMAND
  exit(1) unless $?.success?
end

desc "(Re-)provision an instance"
task :provision => :setup do
  @server ||= Provision::Server.new @args

  @server.ssh "if [ -f /tmp/node.json ]; then sudo mv /tmp/node.json /etc/chef/node.json; fi"
  @server.ssh "sudo chef-solo -N #{@server.name} -j /etc/chef/node.json"
  exit(1) unless $?.success?

  puts "_"*ANSI::Terminal.terminal_width
  puts "\nProvisioned: " + "http://#{@server.node.dns_name}".ansi(:bold)
end

task :setup do
  ENV['AWS_ACCESS_KEY_ID'] || ( puts "\n[!] Missing AWS_ACCESS_KEY_ID environment variable...".ansi(:red) and exit(1) )
  ENV['AWS_SECRET_ACCESS_KEY'] || ( puts "\n[!] Missing AWS_SECRET_ACCESS_KEY environment variable...".ansi(:red) and exit(1) )

  @args = {}
  @args[:name]                  = ENV['NAME']           || 'test-chef-cookbook-elasticsearch'
  @args[:aws_ssh_key_id]        = ENV['AWS_SSH_KEY_ID'] || ENV['USER']
  @args[:aws_access_key_id]     = ENV['AWS_ACCESS_KEY_ID']
  @args[:aws_secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
  @args[:aws_region]            = ENV['AWS_REGION'] || 'us-east-1'
  @args[:aws_groups]            = ENV['AWS_GROUPS'] || 'elasticsearch'
  @args[:aws_flavor]            = ENV['AWS_FLAVOR'] || 't1.micro'
  @args[:aws_image]             = ENV['AWS_IMAGE']  || 'ami-7539b41c'
  @args[:iam_profile]           = ENV['AWS_IAM_ROLE'] || nil
  @args[:ssh_user]              = ENV['SSH_USER']   || 'ubuntu'
  @args[:ssh_key]               = ENV['SSH_KEY']    || File.expand_path("../tmp/#{@args[:aws_ssh_key_id]}.pem", __FILE__)
end
