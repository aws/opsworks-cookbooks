include_recipe 'mysql::service'

template 'mysql configuration' do
  path value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => '/etc/my.cnf'},
    'default' => '/etc/mysql/my.cnf'
    )
  source 'my.cnf.erb'
  backup false
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, "service[mysql]"
end

# CentOS 7 mariadb vs. mysql directory hickup fix
if platform?('centos') && node[:platform_version].to_i >= 7
  execute "Move mariadb log dir" do
    command "mv /var/log/mariadb #{node[:mysql][:logdir]}"
     not_if do
       ( FileTest.directory?(node[:mysql][:logdir]) || !FileTest.directory?("/var/log/mariadb") )
     end
  end

  pidfile_directory = File.dirname(node[:mysql][:pid_file])  
  execute "Move mariadb pidfile directory" do
    command "mv /var/run/mariadb #{pidfile_directory}"
    not_if do
      ( FileTest.directory?(pidfile_directory) || !FileTest.directory?("/var/run/mariadb") )
    end
  end
end