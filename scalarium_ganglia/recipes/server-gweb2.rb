remote_file "/tmp/gweb-2.1.8.tar.gz"  do
  source "gweb-2.1.8.tar.gz"
  mode 0755
  owner "root"
  group "root"
end

directory "/var/www/ganglia2" do
  action :delete
  recursive true
  only_if do
    File.exists?("/var/www/ganglia2")
  end
end

execute "Untar ganglia webfrontend version 2" do
  command "tar -xzf /tmp/gweb-2.1.8.tar.gz && mv /tmp/gweb-2.1.8 /var/www/ganglia2/"
end

execute "fix permissions on ganglia webfrontend version 2" do
  command "chmod -R a+r /var/www/ganglia2/"
end

template "/var/www/ganglia2/Makefile" do
  source "Makefile.erb"
  mode '0644'
end

execute "Execute make install" do
  command "cd /var/www/ganglia2/ && make install"
end

remote_file "/var/www/ganglia2/graph.d/mysql_query_report.php" do
  source "mysql_query_report.php"
  mode "0644"
end

remote_file "/var/www/ganglia2/graph.d/apache_report.php" do
  source "apache_report.php"
  mode "0644"
end

remote_file "/var/www/ganglia2/graph.d/apache_worker_report.php" do
  source "apache_worker_report.php"
  mode "0644"
end

remote_file "/var/www/ganglia2/graph.d/passenger_memory_stats_report.php" do
  source "passenger_memory_stats_report.php"
  mode "0644"
end

remote_file "/var/www/ganglia2/graph.d/passenger_status_report.php" do
  source "passenger_status_report.php"
  mode "0644"
end

remote_file "/var/www/ganglia2/graph.d/haproxy_requests_report.php" do
  source "haproxy_requests_report.php"
  mode "0644"
end

remote_file "/var/www/ganglia2/graph.d/nginx_status_report.php" do
  source "nginx_status_report.php"
  mode "0644"
end

remote_file "/var/www/ganglia2/graph.d/apache_response_time_report.php" do
  source "apache_response_time_report.php"
  mode "0644"
end

template "/var/www/ganglia2/conf.php" do
  source "conf-gweb2.php.erb"
  mode "0644"
end

