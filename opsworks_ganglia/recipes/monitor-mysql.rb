package 'python mysql support' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'MySQL-python'},
    ['debian','ubuntu'] => {'default' => 'python-mysqldb'}
  )
end

template '/etc/ganglia/conf.d/mysql.pyconf' do
  source 'mysql.pyconf.erb'
  owner 'root'
  group 'root'
  mode 0644
end
