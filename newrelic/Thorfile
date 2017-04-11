# encoding: utf-8

require 'bundler'
require 'bundler/setup'
require 'berkshelf/thor'
require 'English'

# Thor (http://whatisthor.com/)
class Default < Thor
  attr_reader :cookbook_name
  attr_reader :cookbook_category

  def initialize(*args)
    @cookbook_name = 'newrelic'
    @cookbook_category = 'Monitoring & Trending'

    super(*args)
  end

  class_option :verbose,
    :type => :boolean,
    :aliases => '-v',
    :default => false

  method_option :knife_config,
    :type => :string,
    :aliases => '-c',
    :desc => 'Path to your knife configuration file',
    :default => '~/.chef/knife.rb'

  desc 'release', 'Create a tag from metadata version and push to the community site.'
  def release
    unless clean?
      say 'Sorry, there are files that need to be committed first.', :red
      exit 1
    end

    tag_version { publish_cookbook(options) }
  end

  private

  def current_version
    Berkshelf::CachedCookbook.from_path(source_root).version
  end

  def clean?
    sh_with_excode('git diff --exit-code')[1] == 0
  end

  def tag_version
    sh "git tag -a -m \"#{current_version}\" #{current_version}"
    say "Tagged: #{current_version}", :green
    yield if block_given?
    sh 'git push --tags'
  rescue => e
    say "Untagging: #{current_version} due to error", :red
    sh_with_excode "git tag -d #{current_version}"
    say e, :red
    say 'Please increase the version in metadata.rb', :red
    exit 1
  end

  def publish_cookbook(options)
    cmd = "knife cookbook site share #{cookbook_name} \"#{cookbook_category}\" -o #{source_root.join('..')} -c #{options[:knife_config]}"
    cmd << ' -V' if options[:verbose]
    sh cmd
    say "Version #{current_version} of the #{cookbook_name} cookbook has been uploaded to the Opscode community site.", :green
  end

  def source_root
    Pathname.new File.dirname(File.expand_path(__FILE__))
  end

  def sh(cmd, dir = source_root, &block)
    out, code = sh_with_excode(cmd, dir, &block)

    if code == 0
      out
    else
      msg = nil

      if out.empty?
        msg = "Running `#{cmd}` failed. Run this command directly for more detailed output."
      else
        msg = out
      end

      fail(msg)
    end
  end

  def sh_with_excode(cmd, dir = source_root, &block)
    cmd << ' 2>&1'
    outbuf = ''

    Dir.chdir(dir) do
      outbuf = `#{cmd}`
      block.call(outbuf) if $CHILD_STATUS == 0 && block
    end

    [outbuf, $CHILD_STATUS]
  end
end
