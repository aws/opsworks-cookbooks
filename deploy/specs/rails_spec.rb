require 'minitest/spec'
require 'yaml'

describe_recipe 'deploy::rails' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'should create bundle' do
    node[:deploy].each do |app, deploy|
      if deploy[:auto_bundle_on_deploy] && deploy[:application_type] == 'rails'
        directory("#{node[:deploy][app][:home]}/.bundler/#{app}").must_exist
      end
    end
  end

  it 'install all dependencies in application' do
    node[:deploy].each do |app, deploy|
      if deploy[:auto_bundle_on_deploy] && deploy[:application_type] == 'rails'
        # Should return 0 if everything's installed correctly.
        assert system("cd #{node[:deploy][app][:deploy_to]}/current && /usr/local/bin/bundle list")
      end
    end
  end

  it 'should write a valid database configuration' do
    node[:deploy].each do |app, deploy|
      next if deploy[:application_type] == 'rails'
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
end
