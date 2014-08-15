require 'minitest/spec'

describe_recipe 'unicorn::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs unicorn' do
    assert system("#{node[:dependencies][:gem_binary]} list | grep unicorn | grep '#{node[:unicorn][:version]}'")
  end
  it 'creates unicorn.conf for every application' do
    node[:deploy].each do |application, deploy|
      file("#{deploy[:deploy_to]}/shared/config/unicorn.conf").must_exist if node[:opsworks][:instance][:layers].include?("#{deploy[:application_type]}-app")
    end
  end

  it 'contains correctly escaped environment variables in unicorn.conf files' do
    node[:deploy].each do |application, deploy|
      deploy[:environment_variables].each do |key, value|
        if node[:opsworks][:instance][:layers].include?("#{deploy[:application_type]}-app")
          file("#{deploy[:deploy_to]}/shared/config/unicorn.conf").must_include(key)
          file("#{deploy[:deploy_to]}/shared/config/unicorn.conf").must_include(value.gsub("\"","\\\"")) unless value.blank?
        end
      end
    end
  end

end
