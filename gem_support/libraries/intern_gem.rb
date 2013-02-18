#
# extend Chef::Recipe with a method to install gem in the bundler environment
# and makes it possible to require them right away.

# because chef run in the Bundler environment
require 'bundler/setup'

module OpsWorks
  module InternalGems

     def self.internal_gem_package(name, options = {})
       options = {
         :version => nil
       }.update(options)
       if OpsWorks::InternalGems.internal_gem_installed?(name, options[:version])
         Chef::Log.info("OpsWorks Gem #{name} #{options[:version]}  is already installed - skipping")
       else
         OpsWorks::InternalGems.install_internal_gem_package(name, options[:version])
       end
       refresh_ruby_load_path
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

     def self.internal_gem_installed?(name, version=nil)
       with_env 'GEM_HOME' => internal_gem_home do
         installed = `/usr/bin/gem list #{name}`.chomp
         if version
           !installed.blank? && !installed.match(version).nil?
         else
           !installed.blank?
         end
       end
     end

     def self.install_internal_gem_package(name, version=nil)
       version = "--version=#{version}" if version
       with_env 'GEM_HOME' => internal_gem_home do
         Chef::Log.info("Installing OpsWorks Gem #{name} #{version}")
         Chef::Log.info(`/usr/bin/gem install #{name} #{version} --no-rdoc --no-ri`)
       end
     end

     def self.refresh_ruby_load_path
       # extend LOAD_PATH, so that we can see this gem in a 'require'.
       Dir.glob("#{internal_gem_home}/gems/*/lib").each do |path|
         $LOAD_PATH  << path unless $LOAD_PATH.include?(path)
       end
     end

  end
end
