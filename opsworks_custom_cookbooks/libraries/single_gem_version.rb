#
# DEPRECATED Module
# this code will be removed on the next agent version.

module OpsWorks
  module GemSupport
    require 'rubygems/version'

    def uninstall_other_gem_versions(name, ensured_version)
      Chef::Log.warn("Using deprecated method OpsWorks::GemSupport.uninstall_other_gem_versions. This method will be removed on the next agent version.")
      versions = `#{node['opsworks_custom_cookbooks']['gem_binary']} list #{name}`
      versions = versions.scan(/(\d[a-zA-Z0-9\.]*)/).flatten.compact
      for version in versions
        next if version == ensured_version
        Chef::Log.info("Uninstalling version #{version} of Rubygem #{name}")
        system("#{node['opsworks_custom_cookbooks']['gem_binary']} uninstall #{name} -v=#{version} #{node['opsworks_custom_cookbooks']['gem_uninstall_options']}")
      end
    end
  end
end

class Chef::Recipe
  include OpsWorks::GemSupport
end
