#
# DEPRECATED Module
# this code will be removed on the next agent version.

module OpsWorks
  module GemSupport
    require 'rubygems/version'

    def gem_provider(name)
      Chef::Log.warn("Using deprecated method OpsWorks::GemSupport.gem_provider. This method will be removed on the next agent version.")
      resource = Chef::Resource::GemPackage.new(name, nil, node)
      provider_class = Chef::Platform.find_provider_for_node(node, resource)
      @gem_provider = provider_class.new(node, resource)
    end

    def current_gem_version(name)
      Chef::Log.warn("Using deprecated method OpsWorks::GemSupport.current_gem_version. This method will be removed on the next agent version.")
      gem_provider(name).load_current_resource.version || "0"
    end

    def new_gem_version_available?(name)
      Chef::Log.warn("Using deprecated method OpsWorks::GemSupport.new_gem_version_available?. This method will be removed on the next agent version.")
      Chef::VERSION > "0.9" || ::Gem::Version.new(gem_provider(name).candidate_version) > ::Gem::Version.new(current_gem_version(name))
    end

    def gem_available?(name)
      Chef::Log.warn("Using deprecated method OpsWorks::GemSupport.gem_available?. This method will be removed on the next agent version.")
      Chef::VERSION > "0.9" || !gem_provider(name).candidate_version.nil?
    end
  end
end

class Chef::Resource
  include OpsWorks::GemSupport
end
