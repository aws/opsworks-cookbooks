include_recipe "apache2::service"

service "gmetad" do
  supports :status => false, :restart => true
  action :nothing
end

template "/etc/ganglia/gmetad.conf" do
  source "gmetad.conf.erb"
  mode '0644'
  variables :cluster_name => node[:scalarium][:cluster][:name]
  notifies :restart, resources(:service => "gmetad")
end

template "/usr/share/ganglia-webfrontend/conf.php" do
  source "conf.php.erb"
  mode '0644'
end

execute "Update htpasswd secret" do
  command "htpasswd -b -c /etc/ganglia-webfrontend/htaccess #{node[:ganglia][:web][:user]} #{node[:ganglia][:web][:password]}"
end

link "/etc/apache2/conf.d/ganglia-webfrontend" do
  to "/etc/ganglia-webfrontend/apache.conf"
  notifies :restart, resources(:service => "apache2")
end

template "/etc/ganglia-webfrontend/apache.conf" do
  source "apache.conf.erb"
  mode '0644'
  notifies :restart, resources(:service => "apache2")
end

template "#{node[:apache][:document_root]}/index.html" do
  source "ganglia.index.html.erb"
  mode '0644'
end

instances = {}

node[:scalarium][:roles].each do |role_name, role_config|
  role_config[:instances].each do |instance_name, instance_config|
    instances[instance_name] ||= []
    instances[instance_name] << role_name
  end
end

# generate individual server view json
instances.keys.each do |instance_name|
  template "#{node[:ganglia][:datadir]}/conf/host_#{instance_name}.json" do
    source 'host_view_json.erb'
    mode '0644'
    variables({:roles => instances[instance_name]})
  end
end

# generate scalarium view json for autorotation
template "#{node[:ganglia][:datadir]}/conf/view_scalarium.json" do
  source 'view_scalarium.json.erb'
  mode '0644'
  variables({:instances => instances})
end

execute "ensure permissions on ganglia rrds directory" do
  command "chown -R #{node[:ganglia][:rrds_user]}:#{node[:ganglia][:user]} #{node[:ganglia][:datadir]}/rrds"
end

execute "Restart gmetad if not running" do # can happen if ganglia role is shared?
  command "(sleep 60 && /etc/init.d/gmetad restart) &"
  not_if "pgrep gmetad"
end