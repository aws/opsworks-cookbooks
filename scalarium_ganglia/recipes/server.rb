
include_recipe "scalarium_ganglia::client"

directory "#{node[:ganglia][:datadir]}/rrds" do
  recursive true
  action :create
  mode "0775"
end

package "ganglia-webfrontend"
package "gmetad"

service "gmetad" do
  supports :status => false, :restart => true
  action :stop
end

template "/etc/ganglia/gmetad.conf" do
  mode '644'
  source "gmetad.conf.erb"
  variables :cluster_name => node[:scalarium][:cluster][:name]
end

remote_file "/usr/share/ganglia-webfrontend/graph.d/mysql_query_report.php" do
  source "mysql_query_report.php"
  mode "0644"
end

remote_file "/usr/share/ganglia-webfrontend/graph.d/apache_report.php" do
  source "apache_report.php"
  mode "0644"
end

remote_file "/usr/share/ganglia-webfrontend/graph.d/apache_worker_report.php" do
  source "apache_worker_report.php"
  mode "0644"
end

remote_file "/usr/share/ganglia-webfrontend/graph.d/passenger_memory_stats_report.php" do
  source "passenger_memory_stats_report.php"
  mode "0644"
end

remote_file "/usr/share/ganglia-webfrontend/graph.d/passenger_status_report.php" do
  source "passenger_status_report.php"
  mode "0644"
end

remote_file "/usr/share/ganglia-webfrontend/graph.d/haproxy_requests_report.php" do
  source "haproxy_requests_report.php"
  mode "0644"
end

remote_file "/usr/share/ganglia-webfrontend/graph.d/nginx_status_report.php" do
  source "nginx_status_report.php"
  mode "0644"
end

remote_file "/usr/share/ganglia-webfrontend/graph.d/apache_response_time_report.php" do
  source "apache_response_time_report.php"
  mode "0644"
end

template "/usr/share/ganglia-webfrontend/conf.php" do
  source "conf.php.erb"
  mode "0644"
end

remote_file "/tmp/scalarium-ganglia-theme.tar.gz"  do
  source "scalarium.tar.gz"
  mode 0755
  owner "root"
  group "root"
end

directory "/usr/share/ganglia-webfrontend/templates/scalarium" do
  action :delete
  recursive true
  only_if do
    File.exists?("/usr/share/ganglia-webfrontend/templates/scalarium")
  end
end

execute "Untar scalarium layout templates for Ganglia" do
  command "tar -xzf /tmp/scalarium-ganglia-theme.tar.gz && mv /tmp/scalarium /usr/share/ganglia-webfrontend/templates/"
end

execute "fix permissions on ganglia webfrontend" do
  command "chmod -R a+r /usr/share/ganglia-webfrontend/"
end

execute "fix permissions on ganglia directory" do
  command "chown -R #{node[:ganglia][:user]}:#{node[:ganglia][:user]} #{node[:ganglia][:datadir]}"
end

execute "fix permissions on ganglia rrds directory" do
  command "chown -R #{node[:ganglia][:rrds_user]}:#{node[:ganglia][:user]} #{node[:ganglia][:datadir]}/rrds"
end


Chef::Log.info("Bindmounting RRDS directories for Ganglia")

mount node[:ganglia][:origina_datadir] do
  device node[:ganglia][:datadir]
  fstype "none"
  options "bind,rw"
  action :mount
end

mount node[:ganglia][:origina_datadir] do
  device node[:ganglia][:datadir]
  fstype "none"
  options "bind,rw"
  action :enable
end
  
service "gmetad" do
  supports :status => false, :restart => true
  action [ :enable, :start ]
end

service "apache2" do
  supports :status => true, :restart => true
  action :restart
end
