require 'minitest/spec'

describe_recipe 'deploy::java' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it "installs and symlinks the mysql driver" do
    @check_apps = node[:deploy].select do |application, deploy|
      node[:deploy][application][:database][:type] == 'mysql'
    end

    skip if @check_apps.none?

    connector_jar = node['opsworks_java']['tomcat']['mysql_connector_jar']
    file(::File.join(node['opsworks_java']['tomcat']['java_shared_lib_dir'], connector_jar)).must_exist
    package(
      value_for_platform_family(
        'rhel' => 'mysql-connector-java',
        'debian' => 'libmysql-java'
      )
    ).must_be_installed
  end

  it "installs and symlinks the postgresql driver" do
    @check_apps = node[:deploy].select do |application, deploy|
      node[:deploy][application][:database][:type] == 'postgresql'
    end

    skip if @check_apps.none?

    connector_jar = node[:platform].eql?('ubuntu') ? 'postgresql-jdbc4.jar' : 'postgresql-jdbc.jar'
    file(::File.join(node['opsworks_java']['tomcat']['java_shared_lib_dir'], connector_jar)).must_exist
    package(
      value_for_platform_family(
        'rhel' => 'postgresql-jdbc',
        'debian' => 'libpostgresql-jdbc-java'
      )
    ).must_be_installed
  end
end
