include_recipe 'apache2::service'
include_recipe 'opsworks_ganglia::service-gmetad'

template '/etc/ganglia/gmetad.conf' do
  source 'gmetad.conf.erb'
  mode '0644'
  variables :stack_name => node[:opsworks][:stack][:name]
  notifies :restart, resources(:service => 'gmetad')
end

template '/usr/share/ganglia-webfrontend/conf.php' do
  source 'conf.php.erb'
  mode '0644'
end

directory '/etc/ganglia-webfrontend' do
  mode '0755'
end

execute 'Update htpasswd secret' do
  command "htpasswd -b -c /etc/ganglia-webfrontend/htaccess #{node[:ganglia][:web][:user]} #{node[:ganglia][:web][:password]}"
end

template '/etc/ganglia-webfrontend/apache.conf' do
  source 'apache.conf.erb'
  mode '0644'
  notifies :restart, resources(:service => 'apache2')
end

link "#{node[:apache][:dir]}/conf.d/ganglia-webfrontend" do
  case node[:platform]
  when 'debian',"ubuntu"
    target_file "#{node[:apache][:dir]}/conf.d/ganglia-webfrontend"
  when 'centos','redhat','fedora','amazon'
    target_file '/etc/httpd/conf.d/ganglia-webfrontend.conf'
  end
  to '/etc/ganglia-webfrontend/apache.conf'
  notifies :restart, resources(:service => 'apache2')
end

template "#{node[:apache][:document_root]}/index.html" do
  source 'ganglia.index.html.erb'
  mode '0644'
end

include_recipe 'opsworks_ganglia::views'

execute 'Restart gmetad if not running' do # can happen if ganglia layer is shared?
  command '(sleep 60 && /etc/init.d/gmetad restart) &'
  not_if 'pgrep gmetad'
end
