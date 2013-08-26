include_recipe 'apache2::service'
include_recipe 'opsworks_ganglia::service-gmetad'

template '/etc/ganglia/gmetad.conf' do
  source 'gmetad.conf.erb'
  mode '0644'
  variables :stack_name => node[:opsworks][:stack][:name]
  notifies :restart, "service[gmetad]"
end

directory '/etc/ganglia-webfrontend' do
  mode '0755'
end

["dwoo/compiled","dwoo/cache"].each do |dir|
  directory "#{node[:ganglia][:datadir]}/#{dir}" do
    owner node[:apache][:user]
    group node[:apache][:group]
    mode '0755'
    recursive true
  end
end

if (node['ganglia']['web']['password'].blank? rescue true)
  Chef::Log.error "Bailing out while configuring Ganglia Server. Password for ganglia webfrontend was not defined. Please set a non-empty password and try again."
  exit 1
end

execute 'Update htpasswd secret' do
  command "htpasswd -b -c /etc/ganglia-webfrontend/htaccess #{node[:ganglia][:web][:user]} #{node[:ganglia][:web][:password]}"
end

case node["platform_family"]
when "debian"
  apache_site "ganglia.conf" do
    enable false
  end

  web_app "opsworks-ganglia" do
    enable true
    notifies :nothing, "service[apache2]"
  end

when "rhel"
  execute "Remove default apache configuration" do
    command "rm -f #{node['apache']['dir']}/conf.d/ganglia.conf"
  end

  template "#{node['apache']['dir']}/conf.d/opsworks-ganglia.conf" do
    source "web_app.conf.erb"
  end
end

directory "#{node[:apache][:document_root]}" do
  owner node[:apache][:user]
  group node[:apache][:group]
  mode '0755'
  not_if { ::File.exists?(node[:apache][:document_root])}
end

template "#{node[:apache][:document_root]}/#{node[:ganglia][:web][:welcome_page]}" do
  source 'ganglia.index.html.erb'
  owner node[:apache][:user]
  group node[:apache][:group]
  mode '0644'
end

include_recipe 'opsworks_ganglia::views'

execute 'Restart gmetad if not running' do # can happen if ganglia layer is shared?
  command '(sleep 60 && /etc/init.d/gmetad restart) &'
  not_if 'pgrep gmetad'
end

service "apache2" do
  action :restart
end
