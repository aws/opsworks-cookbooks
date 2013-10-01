require 'minitest/spec'

describe_recipe 'deploy::php' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs php apps' do
    node[:deploy].each do |application, deploy|
      if deploy[:application_type] = 'php'

        it 'creates a deployment directory' do
          directory(node[:deploy][application][:deploy_to]).must_exist(:mode, '0775').with(:owner, deploy[:user]).and(:group, deploy[:group])
        end

        ['log','config','system','pids','scripts','sockets'].each do |dir_name|
          it "creates a directory #{dir_name} in the deployment directory" do
            directory(node[:deploy][application][:deploy_to] + '/' + dir_name).must_exist(:mode, '0770').with(:owner, deploy[:user]).and(:group, deploy[:group])
          end
        end

        it 'creates the apache site-available link' do
          file("#{node[:apache][:dir]}/sites-available/#{application}.conf").must_exist
        end

        it 'creates the apache site-enabled link' do
          file("#{node[:apache][:dir]}/sites-enabled/#{application}.conf").must_exist
        end

        it 'creates a logrotate configuration' do
          file("/etc/logrotate.d/opsworks_app_#{application}").must_exist(:mode, '0644').with(:owner, 'root').and(:group, 'root')
        end
      end
    end
  end
end
