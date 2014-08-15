require 'minitest/spec'

describe_recipe 'opsworks_nodejs::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'access the right node executable from the default path' do
     (`which node`).chomp.must_equal("/usr/local/bin/node")
  end

  it 'installs nodejs on user space' do
    file("/usr/local/bin/node").must_exist
  end

  it 'installs the expected version of nodejs' do
     (`/usr/local/bin/node --version`).chomp.must_match(/#{node[:opsworks_nodejs][:version]}/)
  end

  it 'access the right npm executable from the default path' do
     (`which npm`).chomp.must_equal("/usr/local/bin/npm")
  end

  it 'installs npm' do
    file("/usr/local/bin/npm").must_exist
  end

  it 'creates app.env for each application' do
    node[:deploy].each do |application, deploy|
      file("#{deploy[:deploy_to]}/shared/app.env").must_exist if node[:opsworks][:instance][:layers].include?("#{deploy[:application_type]}-app")
    end
  end

  it 'contains correctly escaped environment variables in app.env files' do
    node[:deploy].each do |application, deploy|
      deploy[:environment_variables].each do |key, value|
        if node[:opsworks][:instance][:layers].include?("#{deploy[:application_type]}-app")
          file("#{deploy[:deploy_to]}/shared/app.env").must_include(key)
          file("#{deploy[:deploy_to]}/shared/app.env").must_include(value.gsub("\"","\\\"")) unless value.blank?
        end
      end
    end
  end

end
