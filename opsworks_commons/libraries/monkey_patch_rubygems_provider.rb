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

        #
        # manage opsworks user space gems
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
            version = "--version \"#{requirement}\"" unless requirement.nil?
            system "#{@gem_binary} query -i -n #{name} #{version}"
          end
        end


        ##
        # Patch for the Chef::Provider::Package::Rubygems::CurrentGemEnvironment to
        # work on the agent bundled gems and not on system's gems
        class CurrentGemEnvironment < GemEnvironment
          ##
          # Installs a gem via the rubygems ruby API.
          # === Options
          # :sources    rubygems servers to use
          # Other options are passed to the default gem command
          def install(gem_dependency, options={})
            OpsWorksInternalGems.install_internal_gem(
              :name => gem_dependency.name,
              :version => "#{gem_dependency.requirement.requirements.flatten[0]} #{gem_dependency.requirement.requirements.flatten[1].version}".strip,
              :options => options[:opts]
            )
          end

          ##
          # Uninstall the gem +gem_name+ via the rubygems ruby API. If
          # +gem_version+ is provided, only that version will be uninstalled.
          # Otherwise, all versions are uninstalled.
          # === Options
          # Options are passed to the default gem command
          def uninstall(gem_name, gem_version=nil, opts={})
             OpsWorksInternalGems.uninstall_internal_gem(
              :name => gem_name,
              :version => gem_version ? "--version \"#{gem_version}\"" : '--all'
            )
          end
        end

        ##
        # Because in OpsWorks chef runs in a Bundler environment
        class OpsWorksInternalGems
          ##
          # install rubygems into the Bundler environment
          def self.install_internal_gem(options = {})
            options = {
              :name => nil,
              :version => nil,
              :options => nil
            }.update(options)
            if OpsWorksInternalGems.internal_gem_installed?(options[:name], options[:version])
              Chef::Log.info "OpsWorks Gem #{options[:name]} #{options[:version]}  is already installed - skipping"
            else
              OpsWorksInternalGems.install_internal_gem_package(options[:name], options[:version], options[:options])
            end
          end

          ##
          # uninstall rubygems into the Bundler environment
          def self.uninstall_internal_gem(options = {})
            options = {
              :name => nil,
              :version => nil,
              :options => nil
            }.update(options)
            if OpsWorksInternalGems.internal_gem_installed?(options[:name], options[:version])
              OpsWorksInternalGems.uninstall_internal_gem_package(options[:name], options[:version])
            else
              Chef::Log.info "OpsWorks Gem #{options[:name]} #{options[:version]} is not already installed - skipping"
            end
          end

          private

          def self.with_env(options = {})
            old_env = {}
            options.each do |k,v|
              old_env[k] = ENV[k]
              ENV[k] = v
            end
            result = yield
            options.keys.each do |k|
              ENV[k] = old_env[k]
            end
            result
          end

          def self.internal_gem_home
            Bundler.bundle_path.to_s
          end

          def self.uninstall_internal_gem_package(name, version=nil)
            version = "--version \"#{version}\"" if version
            with_env 'GEM_HOME' => internal_gem_home do
              Chef::Log.info "Uninstalling OpsWorks Gem #{name} #{version}"
              Chef::Log.info `/usr/bin/gem uninstall #{name} #{version}`
              refresh_ruby_load_path
            end
          end

          # install a gem in the bundle
          def self.internal_gem_installed?(name,version=nil)
            with_env 'GEM_HOME' => internal_gem_home do
              installed = `/usr/bin/gem list #{name}`.chomp
              if version
                !installed.blank? && !installed.match(version).nil?
              else
                !installed.blank?
              end
            end
          end

          def self.install_internal_gem_package(name, version=nil, options={})
            version = "--version \"#{version}\"" if version
            with_env 'GEM_HOME' => internal_gem_home do
              Chef::Log.info "Installing OpsWorks Gem #{name} #{version}"
              Chef::Log.info `/usr/bin/gem install #{name} #{version} #{options}`
              refresh_ruby_load_path
            end
          end

          # refresh LOAD_PATH, so that we can see this gem in a 'require'
          def self.refresh_ruby_load_path
            current_loadable_paths = Dir.glob("#{internal_gem_home}/gems/*/lib")

            # register newly installed gems into the load path
            current_loadable_paths.map{|path| $LOAD_PATH << path unless $LOAD_PATH.include?(path) }

            # remove deleted gems from load path
            $LOAD_PATH.delete_if{|path| !current_loadable_paths.include?(path) && path =~ /#{internal_gem_home}/}
          end
        end

      end
    end
  end
end
