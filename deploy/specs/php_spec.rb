require 'minitest/spec'

describe_recipe 'deploy::php' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates a deployment directory' do
    node[:deploy].each do |application, deploy|
      if deploy[:application_type] == 'php'
        directory(deploy[:deploy_to]).must_exist.with(:mode, '0775').and(:owner, deploy[:user]).and(:group, deploy[:group])
      end
    end
  end

  ['log','config','system','pids','scripts','sockets'].each do |dir_name|
    it "creates a directory #{dir_name} in the deployment directory" do
      node[:deploy].each do |application, deploy|
        if deploy[:application_type] == 'php'
          directory(::File.join(deploy[:deploy_to], 'shared', dir_name)).must_exist.with(:mode, '0770').and(:owner, deploy[:user]).and(:group, deploy[:group])
        end
      end
    end
  end

  it 'creates the apache site-available link' do
    node[:deploy].each do |application, deploy|
      if deploy[:application_type] == 'php'
        file("#{node[:apache][:dir]}/sites-available/#{application}.conf").must_exist
      end
    end
  end

  it 'creates the apache site-enabled link' do
    node[:deploy].each do |application, deploy|
      if deploy[:application_type] == 'php'
        file("#{node[:apache][:dir]}/sites-enabled/#{application}.conf").must_exist
      end
    end
  end

  it 'creates a logrotate configuration' do
    node[:deploy].each do |application, deploy|
      if deploy[:application_type] == 'php'
        file("/etc/logrotate.d/opsworks_app_#{application}").must_exist.with(:mode, '0644').and(:owner, 'root').and(:group, 'root')
      end
    end
  end
end
