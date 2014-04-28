require 'minitest/spec'

describe_recipe 'rails::configure' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  context 'Opsworks::RailsConfiguration.determine_database_adapter' do
    context 'when the provider is rds' do
      it 'returns the adapter from the app config' do
        check_apps = node[:deploy].select do |name, application| 
          application[:database][:data_source_provider] == 'rds'
        end

        skip unless check_apps.length > 0

        check_apps.each do |name, application|
          adapter = node[:deploy][name]["database"]["adapter"]

          expected_adapter = adapter == 'postgres' ? 'postgresql' : adapter

          assert_equal expected_adapter, OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
        end
      end
    end

    context 'when the provider is stack' do
      it 'returns the adapter from the app config if the force flag is not set' do
        check_apps = node[:deploy].select do |name, application|
          application[:database][:data_source_provider] == 'stack'
        end

        skip unless check_apps.length > 0
        skip if node[:force_database_adapter_detection]

        check_apps.each do |name, application|
          assert_equal node[:deploy][name]["database"]["adapter"], OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
        end
      end
    end

    context 'when the force flag is set' do
      setup do
        skip unless node[:force_database_adapter_detection]
      end

      context 'with a Gemfile' do
        setup do 
          skip unless File.exists?("#{node[:deploy][application][:deploy_to]}/current/Gemfile")
          bundle_list = `cd #{node[:deploy][application][:deploy_to]}/current/Gemfile; /usr/local/bin/bundle list`
        end

        it 'defaults to mysql' do
          skip if bundle_list.include?('mysql2')
          assert_equal 'mysql', OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
        end

        it 'returns mysql2 if in the gemfile' do
          skip unless bundle_list.include?('mysql2')
          assert_equal 'mysql2', OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
        end
      end

      context 'without a Gemfile' do
        it 'returns mysql2 for a rails 3 application' do
          skip unless File.exists?("#{node[:deploy][application][:deploy_to]}/current/application.rb")
          assert_equal 'mysql2', OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
        end

        it 'returns mysql for a rails to application' do
          skip if File.exists?("#{node[:deploy][application][:deploy_to]}/current/application.rb")
          assert_equal 'mysql2', OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
        end
      end
    end
  end
end
