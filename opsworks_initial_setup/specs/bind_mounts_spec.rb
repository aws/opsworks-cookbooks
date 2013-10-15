require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::bind_mounts' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates directories for bind mount' do
    skip unless node[:platform] == 'amazon'
    node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
      directory(dir).must_exist.with(:mode, '755')
      directory(source).must_exist.with(:mode, '755')
    end
  end

  it 'should cover the bind mounts by an autofs map' do
    node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
      assert system("automount -m | grep '#{dir} | -fstype=none,bind,rw :#{source}'")
    end
  end

  it 'should use the platform-dependant ephemeral devices for the bind mounts' do
    # Force automount to do all the bind mounts
    node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
      system("ls '#{dir}'")
    end

    case node[:platform]
    when 'redhat','centos','fedora','amazon'
      ephemeral_mount_point = '/media/ephemeral0'
      httpd_logs_path = '/var/log/httpd'
    when 'debian','ubuntu'
      ephemeral_mount_point = '/mnt'
      httpd_logs_path = '/var/log/apache2'
    end

    mount('/var/log/mysql', :device => "#{ephemeral_mount_point}/var/log/mysql").must_be_mounted
    mount('/srv/www', :device => "#{ephemeral_mount_point}/srv/www").must_be_mounted
    mount('/var/www', :device => "#{ephemeral_mount_point}/var/www").must_be_mounted
    mount(httpd_logs_path, :device => "#{ephemeral_mount_point}/var/log/apache2").must_be_mounted
  end
end
