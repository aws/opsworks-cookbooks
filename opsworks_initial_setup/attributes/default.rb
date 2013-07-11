GC.disable unless node[:opsworks] && node[:opsworks][:instance] && node[:opsworks][:instance][:instance_type] == 't1.micro'

# this values must match the ones respective ones in the agent configuration
default[:opsworks_agent][:base_dir] = '/opt/aws/opsworks'
default[:opsworks_agent][:current_dir] = "#{node[:opsworks_agent][:base_dir]}/current"
default[:opsworks_agent][:shared_dir] = '/var/lib/aws/opsworks'
default[:opsworks_agent][:log_dir] = '/var/log/aws/opsworks'
default[:opsworks_agent][:user] = 'aws'
default[:opsworks_agent][:group] = 'aws'

default[:opsworks][:ruby_stack] = 'ruby_enterprise'
default[:opsworks][:ruby_version] = '1.9.3'
default[:opsworks][:run_cookbook_tests] = false

default[:opsworks_initial_setup][:sysctl] = Mash.new
default[:opsworks_initial_setup][:sysctl]['net.core.somaxconn'] = 1024           # 128
default[:opsworks_initial_setup][:sysctl]['net.core.netdev_max_backlog'] = 3072  # 1000
default[:opsworks_initial_setup][:sysctl]['net.ipv4.tcp_max_syn_backlog'] = 2048 # 1024
default[:opsworks_initial_setup][:sysctl]['net.ipv4.tcp_fin_timeout'] = 30       # 60
default[:opsworks_initial_setup][:sysctl]['net.ipv4.tcp_keepalive_time'] = 1024  # 7200
default[:opsworks_initial_setup][:sysctl]['net.ipv4.tcp_max_orphans'] = 131072   # 32768
default[:opsworks_initial_setup][:sysctl]['net.ipv4.tcp_tw_reuse'] = 1           # 0
default[:opsworks_initial_setup][:limits][:core] = nil
default[:opsworks_initial_setup][:limits][:data] = nil
default[:opsworks_initial_setup][:limits][:fsize] = nil
default[:opsworks_initial_setup][:limits][:memlock] = nil
default[:opsworks_initial_setup][:limits][:nofile] = 65536
default[:opsworks_initial_setup][:limits][:rss] = nil
default[:opsworks_initial_setup][:limits][:stack] = nil
default[:opsworks_initial_setup][:limits][:cpu] = nil
default[:opsworks_initial_setup][:limits][:nproc] = nil
default[:opsworks_initial_setup][:limits][:as] = nil
default[:opsworks_initial_setup][:limits][:maxlogins] = nil
default[:opsworks_initial_setup][:limits][:maxsyslogins] = nil
default[:opsworks_initial_setup][:limits][:priority] = nil
default[:opsworks_initial_setup][:limits][:locks] = nil
default[:opsworks_initial_setup][:limits][:sigpending] = nil
default[:opsworks_initial_setup][:limits][:msgqueue] = nil
default[:opsworks_initial_setup][:limits][:nice] = nil
default[:opsworks_initial_setup][:limits][:rtprio] = nil

default[:opsworks_initial_setup][:yum_dump_file] = File.join(Chef::CHEF_ROOT, "chef", "provider", "package", "yum-dump.py")
default[:opsworks_initial_setup][:yum_dump_lock_timeout] = 120

default[:opsworks_initial_setup][:autofs_map_file] = "/etc/auto.opsworks"

case node[:platform]
when 'redhat','centos','fedora','amazon'
  default[:opsworks_initial_setup][:ephemeral_mount_point] = "/media/ephemeral0"
when 'debian','ubuntu'
  default[:opsworks_initial_setup][:ephemeral_mount_point] = "/mnt"
end

default[:opsworks_initial_setup][:bind_mounts][:mounts] = {
  '/var/log/mysql' => "#{node[:opsworks_initial_setup][:ephemeral_mount_point]}/var/log/mysql",
  '/srv/www' => "#{node[:opsworks_initial_setup][:ephemeral_mount_point]}/srv/www",
  '/var/www' => "#{node[:opsworks_initial_setup][:ephemeral_mount_point]}/var/www",
}
case node[:platform]
when 'redhat','centos','fedora','amazon'
  default[:opsworks_initial_setup][:bind_mounts][:mounts]['/var/log/httpd'] = "#{node[:opsworks_initial_setup][:ephemeral_mount_point]}/var/log/apache2"
when 'debian','ubuntu'
  default[:opsworks_initial_setup][:bind_mounts][:mounts]['/var/log/apache2'] = "#{node[:opsworks_initial_setup][:ephemeral_mount_point]}/var/log/apache2"
end

# landscape removal
default[:opsworks_initial_setup][:landscape][:packages_to_remove] = ['landscape-common', 'landscape-client']
