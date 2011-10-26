include_recipe 'apache2::service'
include_recipe 'scalarium_ganglia::service-gmetad'

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

include_recipe 'scalarium_ganglia::views'

execute "Restart gmetad if not running" do # can happen if ganglia role is shared?
  command "(sleep 60 && /etc/init.d/gmetad restart) &"
  not_if "pgrep gmetad"
end
