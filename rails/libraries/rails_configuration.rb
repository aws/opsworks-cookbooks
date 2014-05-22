module OpsWorks
  module RailsConfiguration
    def self.determine_database_adapter(app_name, app_config, app_root_path, options = {})
      options = {
        :consult_gemfile => true,
        :force => false
      }.update(options)

      unless options[:force] || app_config[:database][:adapter].blank?
        Chef::Log.info("Custom database adapter #{app_config[:database][:adapter].inspect} set and will be used")
        return app_config[:database][:adapter]
      end

      case app_config[:database][:type]
      when 'mysql'
        detect_mysql_driver(app_name, app_root_path, options)
      when 'postgresql'
        Chef::Log.info("Database type is set to postgresql, using the default Rails 'postgresql' adapter")
        'postgresql'
      else
        Chef::Log.warn("Database type is #{app_config[:database][:type].inspect} which Rails cannot auto pickup - please set in custom JSON or via Chef attributes")
        ''
      end
    end

    def self.detect_mysql_driver(app_name, app_root_path, options)
      if options[:consult_gemfile] and File.exists?("#{app_root_path}/Gemfile")
        Chef::Log.info("Gemfile found in #{app_root_path}/Gemfile - detecting MySQL adapter from it.")
        mysql_driver_from_gemfile(app_name, app_root_path, options)
      else
        Chef::Log.info("No Gemfile found in #{app_root_path}/Gemfile - cannot detect database adapter. Guessing from Rails version.")
        mysql_driver_from_application(app_name, app_root_path, options)
      end
    end

    def self.mysql_driver_from_gemfile(app_name, app_root_path, options)
      bundle_list = `cd #{app_root_path}; /usr/local/bin/bundle list`
      if bundle_list.include?('mysql2')
        Chef::Log.info("Looks like #{app_name} uses mysql2 in its Gemfile")
        'mysql2'
      else
        Chef::Log.info("Gem mysql2 not found in the Gemfile of #{app_name}, defaulting to mysql")
        'mysql'
      end
    end

    def self.mysql_driver_from_application(app_name, app_root_path, options)
      if File.exists?("#{app_root_path}/config/application.rb")
        Chef::Log.info("Looks like #{app_name} is a Rails 3 or 4 application, defaulting to mysql2")
        'mysql2'
      else
        Chef::Log.info("No config/application.rb found, assuming #{app_name} is a Rails 2 application, defaulting to mysql")
        'mysql'
      end
    end


  def self.bundle(app_name, app_config, app_root_path)
      if File.exists?("#{app_root_path}/Gemfile")
        Chef::Log.info("Gemfile detected. Running bundle install.")
        Chef::Log.info("sudo su #{app_config[:user]} -c 'cd #{app_root_path} && /usr/local/bin/bundle install --path #{app_config[:home]}/.bundler/#{app_name} --without=#{app_config[:ignore_bundler_groups].join(' ')}'")
        Chef::Log.info(`sudo su #{app_config[:user]} -c 'cd #{app_root_path} && /usr/local/bin/bundle install --path #{app_config[:home]}/.bundler/#{app_name} --without=#{app_config[:ignore_bundler_groups].join(' ')} 2>&1'`)
      end
    end
  end
end
