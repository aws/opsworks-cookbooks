default[:scalarium][:ruby_stack] = 'ruby_enterprise'
default[:scalarium][:run_cookbook_tests] = false
default[:scalarium_initial_setup][:sysctl] = Mash.new
default[:scalarium_initial_setup][:sysctl]['net.core.somaxconn'] = 1024           # 128
default[:scalarium_initial_setup][:sysctl]['net.core.netdev_max_backlog'] = 3072  # 1000
default[:scalarium_initial_setup][:sysctl]['net.ipv4.tcp_max_syn_backlog'] = 2048 # 1024
default[:scalarium_initial_setup][:sysctl]['net.ipv4.tcp_fin_timeout'] = 30       # 60
default[:scalarium_initial_setup][:sysctl]['net.ipv4.tcp_keepalive_time'] = 1024  # 7200
default[:scalarium_initial_setup][:sysctl]['net.ipv4.tcp_max_orphans'] = 131072   # 32768 
default[:scalarium_initial_setup][:sysctl]['net.ipv4.tcp_tw_reuse'] = 1           # 0 
default[:scalarium_initial_setup][:limits][:core] = nil
default[:scalarium_initial_setup][:limits][:data] = nil
default[:scalarium_initial_setup][:limits][:fsize] = nil
default[:scalarium_initial_setup][:limits][:memlock] = nil
default[:scalarium_initial_setup][:limits][:nofile] = 65536
default[:scalarium_initial_setup][:limits][:rss] = nil
default[:scalarium_initial_setup][:limits][:stack] = nil
default[:scalarium_initial_setup][:limits][:cpu] = nil
default[:scalarium_initial_setup][:limits][:nproc] = nil
default[:scalarium_initial_setup][:limits][:as] = nil
default[:scalarium_initial_setup][:limits][:maxlogins] = nil
default[:scalarium_initial_setup][:limits][:maxsyslogins] = nil
default[:scalarium_initial_setup][:limits][:priority] = nil
default[:scalarium_initial_setup][:limits][:locks] = nil
default[:scalarium_initial_setup][:limits][:sigpending] = nil
default[:scalarium_initial_setup][:limits][:msgqueue] = nil
default[:scalarium_initial_setup][:limits][:nice] = nil
default[:scalarium_initial_setup][:limits][:rtprio] = nil

default[:scalarium_initial_setup][:bind_mounts][:mounts] = {
  "/srv/www" => "/mnt/srv/www",
  "/var/www" => "/mnt/var/www",
  "/var/log/apache2" => "/mnt/var/log/apache2",
  "/var/log/mysql" => "/mnt/var/log/mysql"
}

# landscape removal
default[:scalarium_initial_setup][:landscape][:packages_to_remove] = ['landscape-common', 'landscape-client']
