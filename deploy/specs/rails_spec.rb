require 'minitest/spec'

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
end
