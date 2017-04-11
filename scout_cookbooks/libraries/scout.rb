# Helper functions for the chef-scout cookbook
include Chef::Mixin::ShellOut

module Scout
  def self.gem_binary(node)
    ruby_path = node[:scout][:ruby_path] || 'ruby'
    if ruby_path.split(File::SEPARATOR).include?('wrappers') # if an RVM wrapper
      gem_wrapper = File.join(File.dirname(ruby_path), 'gem')
    end

    gem_binary = if gem_wrapper && File.exist?(gem_wrapper)
      gem_wrapper
    else
      ruby_cmd = Mixlib::ShellOut.new(ruby_path, "-e", "require 'rbconfig'; puts RbConfig::CONFIG['bindir']", {}.merge(node[:scout][:gem_shell_opts]||{}))
      ruby_cmd.run_command
      ruby_cmd.error!
      File.join(ruby_cmd.stdout.chop,"gem") rescue nil
    end

    if !File.exist?(gem_binary)
      # Default to chef's built-in gem
      ruby_binary = File.join(RbConfig::CONFIG['bindir'],"gem")
    end

    Chef::Application.fatal!("Cannot find any gem_binary.") if !File.exist?(gem_binary)
    Chef::Log.info "Using gem_binary: #{gem_binary}"
    return gem_binary
  end

  def self.install_gem(node, name_array)
    # name_array can be any array with:
    #   - a single element, e.g. ["scout"]
    #   - multiple elements accepted by 'gem install', e.g. ["scout", "--version", "5.9.5"]
    gem_cmd = Mixlib::ShellOut.new("#{gem_binary(node)}","install", *name_array, {}.merge(node[:scout][:gem_shell_opts]||{}))
    gem_cmd.run_command
    gem_cmd.error!
  end
end
