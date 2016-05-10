module OpsWorks
  module RailsConfiguration
    def self.determine_database_adapter(app_name, app_config, app_root_path, options = {})
      options = {
        :consult_gemfile => true,
        :force => false
      }.update(options)
      if options[:force] || app_config[:database][:adapter].blank?
        Chef::Log.info("No database adapter specified for #{app_name}, guessing")
        adapter = ''

        if options[:consult_gemfile] and File.exists?("#{app_root_path}/Gemfile")
          bundle_list = `cd #{app_root_path}; /usr/local/bin/bundle list`
          adapter = if bundle_list.include?('mysql2')
            Chef::Log.info("Looks like #{app_name} uses mysql2 in its Gemfile")
            'mysql2'
          elsif bundle_list.include?("pg")
            Chef::Log.info("Looks like #{app_name} uses pg in its Gemfile")
            "postgresql"
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
      else
        app_config[:database][:adapter]
      end
    end

    def self.bundle(app_name, app_config, app_root_path)
      if File.exists?("#{app_root_path}/Gemfile")
        Chef::Log.info("Gemfile detected. Running bundle install.")
        Chef::Log.info("sudo su - #{app_config[:user]} -c 'cd #{app_root_path} && /usr/local/bin/bundle install --path #{app_config[:home]}/.bundler/#{app_name} --without=#{app_config[:ignore_bundler_groups].join(' ')}'")
        Chef::Log.info(OpsWorks::ShellOut.shellout("sudo su - #{app_config[:user]} -c 'cd #{app_root_path} && /usr/local/bin/bundle install --path #{app_config[:home]}/.bundler/#{app_name} --without=#{app_config[:ignore_bundler_groups].join(' ')}' 2>&1"))
      end
    end
  end
end
