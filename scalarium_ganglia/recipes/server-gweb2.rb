execute "Get newest version of ganglia web interface from github" do
  command "cd /tmp && git clone git://github.com/vvuksan/ganglia-misc.git"
end

template "/tmp/ganglia-misc/ganglia-web/Makefile" do
  source "Makefile.erb"
  mode '0644'
end

execute "Execute make install" do
  command "cd /tmp/ganglia-misc/ganglia-web/ && make install"
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

