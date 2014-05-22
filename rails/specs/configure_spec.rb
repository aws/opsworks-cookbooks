require 'minitest/spec'

describe_recipe 'rails::configure' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  context 'Opsworks::RailsConfiguration.determine_database_adapter' do
    context 'when the database type is mysql' do
      setup do
        @check_apps = node[:deploy].select do |application, deploy|
          node[:deploy][application][:database][:type] == 'mysql'
        end

        skip if @check_apps.none?
      end

      context 'when there is a Gemfile' do
        it 'defaults to mysql' do
          @check_apps.each do |application, deploy|
            next unless File.exists?("#{node[:deploy][application][:deploy_to]}/current/Gemfile")
            bundle_list = `cd #{node[:deploy][application][:deploy_to]}/current/Gemfile; /usr/local/bin/bundle list`

            next if bundle_list.include?('mysql2')
            assert_equal 'mysql', OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
          end
        end

        it 'returns mysql2 if it is in the gemfile' do
          @check_apps.each do |application, deploy|
            next unless File.exists?("#{node[:deploy][application][:deploy_to]}/current/Gemfile")
            bundle_list = `cd #{node[:deploy][application][:deploy_to]}/current/Gemfile; /usr/local/bin/bundle list`

            next unless bundle_list.include?('mysql2')
            assert_equal 'mysql2', OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
          end
        end
      end

      context 'when there is no Gemfile' do
        it 'returns mysql2 for a rails 3 or 4 application' do
          @check_apps.each do |application, deploy|
            next if File.exists?("#{node[:deploy][application][:deploy_to]}/current/Gemfile")
            next unless File.exists?("#{node[:deploy][application][:deploy_to]}/current/application.rb")
            assert_equal 'mysql2', OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
          end
        end

        it 'returns mysql for a rails 2 application' do
          @check_apps.each do |application, deploy|
            next if File.exists?("#{node[:deploy][application][:deploy_to]}/current/application.rb")
            assert_equal 'mysql', OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
          end
        end
      end
    end

    context 'when the database type is postgres' do
      setup do
        @check_apps = node[:deploy].select do |application, deploy|
          node[:deploy][application][:database][:type] == 'postgresql'
        end

        skip if @check_apps.none?
      end

      it 'returns postgresql' do
        @check_apps.each do |application, deploy|
          assert_equal 'postgresql', OpsWorks::RailsConfiguration.determine_database_adapter(name, node[:deploy][name], "#{node[:deploy][application][:deploy_to]}/current", :force => node[:force_database_adapter_detection])
        end
      end
    end
  end
end
