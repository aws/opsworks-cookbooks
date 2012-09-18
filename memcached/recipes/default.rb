package "memcached" do
  action :upgrade
end

package "libmemcache-dev" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "libmemcache-dev"
  when "centos","redhat","fedora","scientific","amazon","oracle"
    # TODO: No such thing as libmemcache in centos repos. We'll try to use
    # libmemcached, though we'll likely have to use another repo for this.
    package_name "libmemcached-devel"
  end
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

if node[:platform] == 'ubuntu' or node[:platform] == 'debian'
  template "/etc/default/memcached" do
    source "memcached.default.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, resources(:service => "memcached"), :immediately
  end
end

template "/etc/monit/conf.d/memcached.monitrc" do
  source "memcached.monitrc.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "monit")
end

include_recipe "memcached::prepare_tests" if node[:scalarium][:run_cookbook_tests]
