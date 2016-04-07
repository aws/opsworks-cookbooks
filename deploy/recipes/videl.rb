include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|
  
  execute "updating crontab" do
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec whenever -w -s environment=#{deploy[:env]}"
    action :run
  end

  template "#{deploy[:deploy_to]}/shared/config/settings.yml" do
    source 'videl/settings.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :videl_settings => node[:settings],
      :videl_env => deploy[:env]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end


  node[:senders].each do |name, conf|
    if conf.has_key?(:sftp)
      private_key_file = "/home/#{deploy[:user]}/.ssh/#{name}.pem"
      template private_key_file do
        source 'videl/sftp.pem.erb'
        mode '0600'
        owner deploy[:user]
        group deploy[:group]
        variables :private_key => conf[:sftp][:private_key_file]
      end
      node.default[:senders][name][:sftp][:private_key_file] = private_key_file
    end

    template "#{deploy[:deploy_to]}/shared/config/#{name}.yml" do
      source "videl/sender.yml.erb"
      mode '0660'
      owner deploy[:user]
      group deploy[:group]
      variables(
          :name => name,
          :conf => sender_config
      )
      only_if do
        File.exists?("#{deploy[:deploy_to]}/shared/config")
      end
    end

  end






end
