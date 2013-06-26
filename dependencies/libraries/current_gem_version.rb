module OpsWorks
  module GemSupport
    require 'rubygems/version'

    def ensure_only_gem_version(name, ensured_version)
      versions = `#{node[:dependencies][:gem_binary]} list #{name}`
      versions = versions.scan(/(\d[a-zA-Z0-9\.]*)/).flatten.compact
      for version in versions
        next if version == ensured_version
        Chef::Log.info("Uninstalling version #{version} of Rubygem #{name}")
        system("#{node[:dependencies][:gem_binary]} uninstall #{name} -v=#{version} #{node['dependencies']['gem_uninstall_options']}")
      end
      if versions.include?(ensured_version)
        Chef::Log.info("Skipping installation of version #{ensured_version} of Rubygem #{name}: already installed")
      else
        Chef::Log.info("Installing version #{ensured_version} of Rubygem #{name}")
        system("#{node[:dependencies][:gem_binary]} install #{name} -v=#{ensured_version} #{node['dependencies']['gem_install_options']}")
      end
    end
  end
end

class Chef::Resource
  include OpsWorks::GemSupport
end
