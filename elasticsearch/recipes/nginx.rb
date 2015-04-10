# Install Nginx via packages
#
package "nginx"

# Create user and group for Nginx
#
user node[:nginx][:user] do
  comment "Nginx User"
  system true
  shell "/bin/false"
  action :create
end
group node[:nginx][:user] do
  members node[:nginx][:user]
  action :create
end

# Create service for Nginx (/sbin/service nginx)
#
service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Create log directory
#
directory node[:nginx][:log_dir] do
  mode 0755
  owner 'root'
  action :create
  recursive true
end

# Create Nginx main configuration file
#
template "nginx.conf.erb" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  mode 0644
  notifies :restart, 'service[nginx]', :immediately
end

if node.recipes.include?('monit') and respond_to?(:monitrc)
  monitrc "nginx.monitrc" do
    template_cookbook 'elasticsearch'
    source 'nginx.monitrc.conf.erb'
  end
end
