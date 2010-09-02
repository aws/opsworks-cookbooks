default[:scalarium_initial_setup][:sysctl] = Mash.new
default[:scalarium_initial_setup][:sysctl]['net.core.somaxconn'] = 1024           # 128
default[:scalarium_initial_setup][:sysctl]['net.core.netdev_max_backlog'] = 3072  # 1000
default[:scalarium_initial_setup][:sysctl]['net.ipv4.tcp_max_syn_backlog'] = 2048 # 1024
default[:scalarium_initial_setup][:sysctl]['net.ipv4.tcp_fin_timeout'] = 30       # 60
default[:scalarium_initial_setup][:sysctl]['net.ipv4.tcp_keepalive_time'] = 1024  # 7200
default[:scalarium_initial_setup][:sysctl]['net.ipv4.tcp_max_orphans'] = 131072   # 32768 
default[:scalarium_initial_setup][:sysctl]['net.ipv4.tcp_tw_reuse'] = 1           # 0 