require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::bind_mounts' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates directories for bind mount' do
    node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
      directory(dir).must_exist
      directory(source).must_exist
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

    ephemeral_device = `grep #{ephemeral_mount_point} /proc/mounts`.split.first

    file('/proc/mounts').must_match %r{^#{ephemeral_device}\s/var/log/mysql\s}
    file('/proc/mounts').must_match %r{^#{ephemeral_device}\s/srv/www\s}
    file('/proc/mounts').must_match %r{^#{ephemeral_device}\s/var/www\s}
    file('/proc/mounts').must_match %r{^#{ephemeral_device}\s#{httpd_logs_path}\s}
  end
end
