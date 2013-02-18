# put new UI in place
directory "/usr/share/ganglia-webfrontend/" do
  action :create
  recursive true
  owner 'root'
  group 'root'
end

execute "Ensure Ganglia webfront folder is clean (idempotence)" do
  command "rm -rf /usr/share/ganglia-webfrontend/*"
end

cookbook_file "/tmp/opsworks-ganglia-gweb-2.1.8.tar.gz" do
  source "opsworks-ganglia-gweb-2.1.8.tar.gz"
  mode "0644"
end

execute "Untar opsworks reports for Ganglia" do
  command "tar -xzf /tmp/opsworks-ganglia-gweb-2.1.8.tar.gz && mv /tmp/opsworks-ganglia-gweb-2.1.8/* /usr/share/ganglia-webfrontend/"
end

# replace default reports
execute "Clean Ganglia reports folder" do
  command "rm -rf /usr/share/ganglia-webfrontend/graph.d/*"
end

cookbook_file "/tmp/opsworks-ganglia-reports.tar.gz" do
  source "opsworks-ganglia-reports.tar.gz"
  mode "0644"
end

execute "Untar opsworks reports for Ganglia" do
  command "tar -xzf /tmp/opsworks-ganglia-reports.tar.gz && mv /tmp/opsworks-ganglia-reports/* /usr/share/ganglia-webfrontend/graph.d/"
end

# add opsworks template
cookbook_file "/tmp/opsworks-ganglia-templates.tar.gz"  do
  source "opsworks-ganglia-templates.tar.gz"
  mode "0644"
end

execute "Untar opsworks layout templates for Ganglia" do
  command "tar -xzf /tmp/opsworks-ganglia-templates.tar.gz && mv /tmp/opsworks-ganglia-templates /usr/share/ganglia-webfrontend/templates/opsworks"
end

# initialize new UI
template "/usr/share/ganglia-webfrontend/Makefile" do
  source "Makefile.erb"
  mode '0644'
end

execute "Execute make install" do
  command "cd /usr/share/ganglia-webfrontend/ && make install"
end

directory node[:ganglia][:events_dir] do
  mode '0755'
  action :create
  recursive true
  owner node[:ganglia][:web][:apache_user]
end

# add config overrides
template "/usr/share/ganglia-webfrontend/conf.php" do
  source "conf.php.erb"
  mode "0644"
end

# fix permissions and clean tmp
execute "fix permissions on ganglia webfrontend" do
  command "chmod -R a+r /usr/share/ganglia-webfrontend/"
end

execute "fix permissions on ganglia rrds directory" do
  command "chown -R #{node[:ganglia][:rrds_user]}:#{node[:ganglia][:user]} #{node[:ganglia][:datadir]}/rrds"
end

execute "Cleanup" do
  command "rm -rf /tmp/opsworks-ganglia*"
end
