

events_dir = node[:ganglia][:datadir] + '/conf/events.json.d/'

directory events_dir do
  mode '0755'
  action :create
  recursive true
  owner 'www-data'
end

template "/var/www/ganglia2/conf.php" do
  source "conf-gweb2.php.erb"
  mode "0644"
end