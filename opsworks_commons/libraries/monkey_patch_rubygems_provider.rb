#
# Support opsworks user-space ruby stacks
require 'chef/provider/package'

class Chef
  class Provider
    class Package
      class Rubygems < Chef::Provider::Package
        class AlternateGemEnvironment < GemEnvironment

          def gem_specification
            # The original Chef way just setting Gem::Specification.dirs = [...]
            # is broken, as the instance agent runs inside bundler. So manually
            # load the specs.
            all = gem_paths.map do |path|
              Dir.glob("#{path}/specifications/*.gemspec").map do |file|
                Chef::Log.debug "Loading spec from file: #{file}"
                Gem::Specification.load(file)
              end
            end

            Gem::Specification.all = all.flatten
            return Gem::Specification
          end
        end

        def is_omnibus?
          # Make Chef believe it runs inside Omnibus. This will cause
          # the AlternateGemEnvironment to be used (except for chef_gem)
          return true
        end
      end
    end
  end
end
