
template "#{node[:nginx][:dir]}/conf.d/api.conf" do
  source "api.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{node[:nginx][:dir]}/conf.d/upstreams.conf" do
  source "upstreams.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

include_recipe "nginx::service"

service "nginx" do
  action [ :reload ]
end