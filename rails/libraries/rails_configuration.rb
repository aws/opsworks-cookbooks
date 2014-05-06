module OpsWorks
  module RailsConfiguration
    def self.determine_database_adapter(app_name, app_config, app_root_path, options = {})
      options = {
        :consult_gemfile => true,
        :force => false
      }.update(options)

      adapter = app_config["database"]["adapter"]
      data_source_provider = app_config["database"]["data_source_provider"]

      if data_source_provider == 'rds'
        return adapter == 'mysql' ? 'mysql2' : 'postgresql'
      end

      # ensure that if a customer has set an adapter in the custom JSON,
      # it will not be not overridden
      return adapter unless ['postgresql', 'mysql'].include? adapter

      return 'mysql2' unless options[:force]

      Chef::Log.info("No database adapter specified for #{app_name}, guessing")
      adapter = ''

      if options[:consult_gemfile] and File.exists?("#{app_root_path}/Gemfile")
        bundle_list = `cd #{app_root_path}; /usr/local/bin/bundle list`
        adapter = if bundle_list.include?('mysql2')
          Chef::Log.info("Looks like #{app_name} uses mysql2 in its Gemfile")
          'mysql2'
        else
          Chef::Log.info("Gem mysql2 not found in the Gemfile of #{app_name}, defaulting to mysql")
          'mysql'
        end
      else # no Gemfile - guess adapter by Rails version
        adapter = if File.exists?("#{app_root_path}/config/application.rb")
          Chef::Log.info("Looks like #{app_name} is a Rails 3 application, defaulting to mysql2")
          'mysql2'
        else
          Chef::Log.info("No config/application.rb found, assuming #{app_name} is a Rails 2 application, defaulting to mysql")
          'mysql'
        end
      end

      adapter
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
