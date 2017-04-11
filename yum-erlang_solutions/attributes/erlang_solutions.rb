case node['platform_family']
when 'rhel'
  default['yum']['erlang_solutions']['baseurl'] = 'http://packages.erlang-solutions.com/rpm/centos/6/$basearch'
else
  default['yum']['erlang_solutions']['baseurl'] = 'http://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch'
end
default['yum']['erlang_solutions']['description'] = 'Centos $releasever - $basearch - Erlang Solutions'
default['yum']['erlang_solutions']['gpgkey'] = 'http://packages.erlang-solutions.com/debian/erlang_solutions.asc'
default['yum']['erlang_solutions']['gpgcheck'] = false
default['yum']['erlang_solutions']['enabled'] = true
