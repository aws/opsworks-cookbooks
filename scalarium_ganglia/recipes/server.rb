include_recipe "scalarium_ganglia::client"

directory "#{node[:ganglia][:datadir]}/rrds" do
  recursive true
  action :create
  mode "0775"
end

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

execute "Remove old Ganglia UI" do
  command "rm -rf /usr/share/ganglia-webfrontend/*"
end

# put new UI in place
remote_file "/tmp/scalarium-ganglia-gweb-2.1.8.tar.gz" do
  source "scalarium-ganglia-gweb-2.1.8.tar.gz"
  mode "0644"
end

execute "Untar scalarium reports for Ganglia" do
  command "tar -xzf /tmp/scalarium-ganglia-gweb-2.1.8.tar.gz && mv /tmp/scalarium-ganglia-gweb-2.1.8/* /usr/share/ganglia-webfrontend/"
end

# replace default reports
execute "Clean Ganglia reports folder" do
  command "rm -rf /usr/share/ganglia-webfrontend/graph.d/*"
end

remote_file "/tmp/scalarium-ganglia-reports.tar.gz" do
  source "scalarium-ganglia-reports.tar.gz"
  mode "0644"
end

execute "Untar scalarium reports for Ganglia" do
  command "tar -xzf /tmp/scalarium-ganglia-reports.tar.gz && mv /tmp/scalarium-ganglia-reports /usr/share/ganglia-webfrontend/graph.d/"
end

# add scalarium template
remote_file "/tmp/scalarium-ganglia-templates.tar.gz"  do
  source "scalarium-ganglia-templates.tar.gz"
  mode "0644"
end

execute "Untar scalarium layout templates for Ganglia" do
  command "tar -xzf /tmp/scalarium-ganglia-templates.tar.gz && mv /tmp/scalarium-ganglia-templates /usr/share/ganglia-webfrontend/templates/"
end

# initialize new UI
template "/usr/share/ganglia-webfrontend/Makefile" do
  source "Makefile.erb"
  mode '0644'
end

execute "Execute make install" do
  command "cd /usr/share/ganglia-webfrontend/ && make install"
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

execute "fix permissions on ganglia directory" do
  command "chown -R #{node[:ganglia][:user]}:#{node[:ganglia][:user]} #{node[:ganglia][:datadir]}"
end

execute "fix permissions on ganglia rrds directory" do
  command "chown -R #{node[:ganglia][:rrds_user]}:#{node[:ganglia][:user]} #{node[:ganglia][:datadir]}/rrds"
end

execute "Untar scalarium reports for Ganglia" do
  command "rm -rf /tmp/scalarium-ganglia*"
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
