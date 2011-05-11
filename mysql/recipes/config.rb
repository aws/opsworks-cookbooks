include_recipe 'mysql::service'

template value_for_platform([ "centos", "redhat", "suse" ] => {"default" => "/etc/my.cnf"}, "default" => "/etc/mysql/my.cnf") do
  source "my.cnf.erb"
  backup false
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "mysql")
end