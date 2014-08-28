require 'minitest/spec'
require 'yaml'

describe_recipe 'rails::configure' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'should update the database configuration' do
    node[:deploy].each do |app, deploy|
      next unless deploy[:application_type] == 'rails'
      skip unless deploy[:database][:host].present?

      cfg = YAML.load_file("#{deploy[:deploy_to]}/shared/config/database.yml")

      ["development", "production", deploy[:rails_env]].uniq.each do |env|
        cfg[env]['adapter'].must_equal deploy[:database][:adapter].to_s
        cfg[env]['database'].must_equal deploy[:database][:database].to_s
        cfg[env]['host'].must_equal((deploy[:database][:host] || 'localhost').to_s)
        cfg[env]['username'].must_equal deploy[:database][:username].to_s
        cfg[env]['password'].must_equal((deploy[:database][:password] || '').to_s)
        cfg[env]['reconnect'].must_equal deploy[:database][:reconnect] ? true : false
        cfg[env]['port'].must_equal deploy[:database][:port].to_i if deploy[:database][:port]
      end
    end
  end

  it 'should update the memcached configuration' do
    node[:deploy].each do |app, deploy|
      next unless deploy[:application_type] == 'rails'
      skip unless deploy[:memcached][:host].present?

      cfg = YAML.load_file("#{deploy[:deploy_to]}/shared/config/memcached.yml")

      ["development", "production", deploy[:rails_env]].uniq.each do |env|
        cfg[env]['host'].must_equal((deploy[:memcached][:host] || 'localhost').to_s)
        cfg[env]['port'].must_equal deploy[:memcached][:port].to_i if deploy[:memcached][:port]
      end
    end
  end

  it 'should restart the application after updating the configuration' do
    node[:deploy].each do |app, deploy|
      next unless deploy[:application_type] == 'rails'
      skip
    end
  end

  describe 'Opsworks::RailsConfiguration.determine_database_adapter' do
    describe 'when the database type is mysql' do
      before :all do
        @check_apps = node[:deploy].select do |application, deploy|
          deploy[:database][:type] == 'mysql'
        end

        skip if @check_apps.none?
      end

      describe 'when there is a Gemfile' do
        it 'defaults to mysql' do
          @check_apps.each do |application, deploy|
            next unless File.exists?("#{deploy[:deploy_to]}/current/Gemfile")
            bundle_list = `cd #{deploy[:deploy_to]}/current ; /usr/local/bin/bundle list`

            next if bundle_list.include?('mysql2')
            assert_equal 'mysql', OpsWorks::RailsConfiguration.determine_database_adapter(application, deploy, "#{deploy[:deploy_to]}/current", :force => node[:force_database_adapter_detection])
          end
        end

        it 'returns mysql2 if it is in the Gemfile' do
          @check_apps.each do |application, deploy|
            next unless File.exists?("#{deploy[:deploy_to]}/current/Gemfile")
            bundle_list = `cd #{deploy[:deploy_to]}/current ; /usr/local/bin/bundle list`

            next unless bundle_list.include?('mysql2')
            assert_equal 'mysql2', OpsWorks::RailsConfiguration.determine_database_adapter(application, deploy, "#{deploy[:deploy_to]}/current", :force => node[:force_database_adapter_detection])
          end
        end
      end

      describe 'when there is no Gemfile' do
        it 'returns mysql2 for a rails 3 or 4 application' do
          @check_apps.each do |application, deploy|
            next if File.exists?("#{deploy[:deploy_to]}/current/Gemfile")
            next unless File.exists?("#{deploy[:deploy_to]}/current/config/application.rb")
            assert_equal 'mysql2', OpsWorks::RailsConfiguration.determine_database_adapter(application, deploy, "#{deploy[:deploy_to]}/current", :force => node[:force_database_adapter_detection])
          end
        end

        it 'returns mysql for a rails 2 application' do
          @check_apps.each do |application, deploy|
            next if File.exists?("#{deploy[:deploy_to]}/current/Gemfile")
            next if File.exists?("#{deploy[:deploy_to]}/current/config/application.rb")
            assert_equal 'mysql', OpsWorks::RailsConfiguration.determine_database_adapter(application, deploy, "#{deploy[:deploy_to]}/current", :force => node[:force_database_adapter_detection])
          end
        end
      end
    end

    describe 'when the database type is postgres' do
      before :all do
        @check_apps = node[:deploy].select do |application, deploy|
          deploy[:database][:type] == 'postgresql'
        end

        skip if @check_apps.none?
      end

      it 'returns postgresql' do
        @check_apps.each do |application, deploy|
          assert_equal 'postgresql', OpsWorks::RailsConfiguration.determine_database_adapter(application, deploy, "#{deploy[:deploy_to]}/current", :force => node[:force_database_adapter_detection])
        end
      end
    end
  end
end
