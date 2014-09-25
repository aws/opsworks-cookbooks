require 'minitest/spec'

describe_recipe 'opsworks_java::context' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates xml configuration file for every application' do
    node[:deploy].each do |application, deploy|
      application = "ROOT" if application == "root"
      file("#{node['opsworks_java'][node['opsworks_java']['java_app_server']]['context_dir']}/#{application}.xml").must_exist if node[:opsworks][:instance][:layers].include?("#{deploy[:application_type]}-app")
    end
  end

  it 'contains correctly escaped environment variables in application context containers' do
    node[:deploy].each do |application, deploy|
      application = "ROOT" if application == "root"
      deploy[:environment_variables].each do |key, value|
        if node[:opsworks][:instance][:layers].include?("#{deploy[:application_type]}-app")
          char_map = {"&" => "&amp;", "\"" => "&quot;", "'" => "&apos;", "<" => "&lt;", ">" => "&gt;"}
          file("#{node['opsworks_java'][node['opsworks_java']['java_app_server']]['context_dir']}/#{application}.xml").must_include(key)
          file("#{node['opsworks_java'][node['opsworks_java']['java_app_server']]['context_dir']}/#{application}.xml").must_include(value.gsub(/[&"'<>]/, char_map)) unless value.blank?
        end
      end
    end
  end

end
