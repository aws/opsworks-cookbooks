#
# set default options for ChefGem and thus fix installation procedure to use the
# Chef::Provider::Package::Rubygems#install and Chef::Provider::Package::Rubygems#uninstall
# methods

require 'chef/resource/package'
require 'chef/resource/gem_package'

class Chef
  class Resource
    class ChefGem < Chef::Resource::Package::GemPackage
      ##
      # Options for the gem install, either a Hash or a String. When a hash is
      # given, the options are passed to Gem::DependencyInstaller.new, and the
      # gem will be installed via the gems API. When a String is given, the gem
      # will be installed by shelling out to the gem command. Using a Hash of
      # options with an explicit gem_binary will result in undefined behavior.
      def options(opts={:opts => "--no-ri --no-rdoc"})
        set_or_return(:options,opts,:kind_of => [String,Hash])
      end
    end
  end
end
