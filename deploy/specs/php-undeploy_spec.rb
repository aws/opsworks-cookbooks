require 'minitest/spec'

describe_recipe 'deploy::php-undeploy' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'deletes the apache site-enabled link' do
    if deploy[:application_type] = 'php'
      file("#{node[:apache][:dir]}/sites-enabled/#{application}.conf").wont_exist
    end
  end

  it 'deletes the apache site-available link' do
    if deploy[:application_type] = 'php'
      file("#{node[:apache][:dir]}/sites-available/#{application}.conf").wont_exist
    end
  end

  it 'deletes the application directory' do
    if deploy[:application_type] = 'php'
      directory("#{deploy[:deploy_to]}").wont_exist
    end
  end
end
