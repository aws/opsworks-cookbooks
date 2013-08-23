#
# Set node[:dependencies][:gem_binary] as default rubygems binary
require 'chef/resource/package'

class Chef
  class Resource
    class GemPackage < Chef::Resource::Package
      # Sets a custom gem_binary to run for gem commands.
      def gem_binary( gem_cmd = node[:dependencies][:gem_binary] )
        set_or_return(:gem_binary,gem_cmd,:kind_of => [ String ])
      end
    end
  end
end
