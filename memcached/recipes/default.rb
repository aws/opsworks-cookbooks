package "memcached" do
  action :upgrade
end

package "libmemcache-dev" do
  action :upgrade
end

include_recipe "memcached::service"

service "monit" do
  action :nothing
end

template "/etc/memcached.conf" do
  source "memcached.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :user => node[:memcached][:user],
    :port => node[:memcached][:port],
    :memory => node[:memcached][:memory]
  )
  notifies :restart, resources(:service => "memcached"), :immediately
end

template "/etc/default/memcached" do
  source "memcached.default.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "memcached"), :immediately
end

template "/etc/monit/conf.d/memcached.monitrc" do
  source "memcached.monitrc.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end

include_recipe "memcached::prepare_tests" if node[:scalarium][:run_cookbook_tests]
