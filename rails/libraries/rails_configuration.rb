module Scalarium
  module RailsConfiguration
    def self.determine_database_adapter(app_name, app_config, app_root_path, force)
      if force || app_config[:database][:adapter].blank?
        Chef::Log.info("No database adapter specified for #{app_name}, guessing")
        adapter = ''

        if app_config[:auto_bundle_on_deploy] and File.exists?("#{app_root_path}/Gemfile")
          bundle_list = `cd #{app_root_path}; bundle list`
          adapter = if bundle_list.include?('mysql2')
            Chef::Log.info("Looks like #{app_name} uses mysql2 in its Gemfile")
            'mysql2'
          else
            Chef::Log.info("Gem mysql2 not found in the Gemfile of #{app_name}, defaulting to mysql")
            'mysql'
          end
        else # no Gemfile - guess adapter by Rails version
          adapter = if File.exists?("#{app_root_path}/config/app_name.rb")
            Chef::Log.info("Looks like #{app_name} is a Rails 3 app_name, defaulting to mysql2")
            'mysql2'
          else
            Chef::Log.info("No config/app_name.rb found, assuming #{app_name} is a Rails 2 app_name, defaulting to mysql")
            'mysql'
          end
        end

        adapter
      else
        app_config[:database][:adapter]
      end
    end

    def self.bundle(app_name, app_config, app_root_path)
      if File.exists?("#{app_root_path}/Gemfile")
        Chef::Log.info("Gemfile detected. Running bundle install.")
        Chef::Log.info(`sudo su deploy -c 'cd #{app_root_path} && bundle install #{app_config[:home]}/.bundler/#{app_name} --without=test development'`)
      end
    end
  end
end
