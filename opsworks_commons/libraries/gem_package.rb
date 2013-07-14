
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


#
# Support opsworks user-space ruby stacks
require 'chef/provider/package'

class Chef
  class Provider
    class Package
      class Rubygems < Chef::Provider::Package
        class GemEnvironment
          ##
          # Lists the installed versions of +gem_dep.name+, constrained by the
          # version spec in +gem_dep.requirement+
          # Uses OpsWorksUserSpaceGems.installed_versions to find gem in the
          # OpsWorks user space ruby environment if @gem_binary_location id defined
          #
          # === Arguments
          # Gem::Dependency   +gem_dep+ is a Gem::Dependency object, its version
          #                   specification constrains which gems are returned.
          # === Returns
          # [Gem::Specification]  an array of Gem::Specification objects
          def installed_versions(gem_dep)
            # @gem_binary_location is defined in Chef::Resource::GemPackage
            if @gem_binary_location.present? && ::File.exists?(@gem_binary_location)
                OpsWorksUserSpaceGems.new(@gem_binary_location).installed_versions(
                  gem_dep.name,
                  gem_dep.requirement
                )
            elsif Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.8.0')
                gem_specification.find_all_by_name(gem_dep.name, gem_dep.requirement)
              else
                gem_source_index.search(gem_dep)
            end
          end
        end

        class OpsWorksUserSpaceGems
          def initialize(gem_binary)
            @gem_binary = gem_binary
          end

          ##
          # Lists the installed versions of +gem_dep.name+, constrained by the
          # version spec in +gem_dep.requirement+
          # === Arguments
          # name          the name of the gem to look for
          # requirement   the requirement for this gem
          # === Returns
          # [Gem::Specification]  an array of Gem::Specification objects
          def installed_versions(name, requirement)
            if gem_installed?(name, requirement)
              Chef::Log.info "Gem #{name} (#{requirement}) found in OpsWorks user space."
              # from rubygems/specification.rb#find_all_by_name
              Gem::Dependency.new(name, requirement).matching_specs
            else
              Chef::Log.debug "Gem #{name} (#{requirement}) not found in OpsWorks user space."
              []
            end
          end

          private

          def gem_installed?(name, requirement)
            if requirement.nil?
               system "#{@gem_binary} query -i -n #{name}"
            else
               system "#{@gem_binary} query -i -n #{name} -v '#{requirement}'"
            end
          end
        end

      end
    end
  end
end
