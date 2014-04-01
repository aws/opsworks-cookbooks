#
# Support opsworks user-space ruby stacks
require 'chef/provider/package'

class Chef
  class Provider
    class Package
      class Rubygems < Chef::Provider::Package
        class GemEnvironment
          def self.gem_specification_from_filesystem(paths)
            # The original Chef way just setting Gem::Specification.dirs = [...]
            # is broken, as the instance agent runs inside bundler. So manually
            # load the specs.
            all = paths.map do |path|
              Dir.glob("#{path}/specifications/*.gemspec").map do |file|
                Chef::Log.debug "Loading spec from file: #{file}"
                Gem::Specification.load(file)
              end
            end

            Gem::Specification.all = all.flatten
            return Gem::Specification
          end
        end

        class CurrentGemEnvironment < GemEnvironment
          def with_env(options = {})
            old_env = ENV.to_h
            ENV.update(options)
            result = yield
            ENV.clear
            ENV.update(old_env)
            result
          end

          def gem_binary_location
            ::File.join(RbConfig::CONFIG['bindir'], "gem")
          end

          def gem_home
            Bundler.bundle_path.to_s
          end

          def refresh_ruby_load_path
            current_loadable_paths = Dir.glob("#{gem_home}/gems/*/lib")

            # register newly installed gems into the load path
            current_loadable_paths.each {|path| $LOAD_PATH << path unless $LOAD_PATH.include?(path)}

            # remove deleted gems from load path
            $LOAD_PATH.delete_if {|path| !current_loadable_paths.include?(path) && path =~ /#{gem_home}/}
          end

          def install(gem_dependency, options={})
            name = gem_dependency.name
            version = "#{gem_dependency.requirement.requirements.flatten[0]} #{gem_dependency.requirement.requirements.flatten[1].version}".strip
            opts = options[:opts] ? options[:opts] : ""

            with_env 'GEM_HOME' => gem_home do
              Chef::Log.info "Installing chef-gem #{name} #{version}"
              Chef::Log.info `#{gem_binary_location} install #{name} -q --no-rdoc --no-ri --version '#{version}' #{opts}`
              refresh_ruby_load_path
            end
          end

          def uninstall(gem_name, gem_version=nil, opts={})
            args = gem_version ? "--version #{gem_version}" : "--all"

            with_env 'GEM_HOME' => gem_home do
              Chef::Log.info "Un-Installing chef-gem #{gem_name} #{gem_version}"
              Chef::Log.info `#{gem_binary_location} uninstall -q -x -I #{gem_name} #{args}`
              refresh_ruby_load_path
            end
          end

          def gem_specification
            gem_specs = GemEnvironment.gem_specification_from_filesystem([gem_home])

            # Refresh the list of installed Gems. Otherwise only Gems referenced in
            # the Gemfile are visible - not the user installed ones.
            refresh_ruby_load_path
            return gem_specs
          end
        end

        class AlternateGemEnvironment < GemEnvironment
          def gem_specification
            GemEnvironment.gem_specification_from_filesystem(gem_paths)
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
