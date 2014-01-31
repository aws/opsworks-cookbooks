execute 'enable mod_proxy for apache-tomcat binding' do
  command '/usr/sbin/a2enmod proxy'
  not_if do
    ::File.symlink?(::File.join(node['apache']['dir'], 'mods-enabled', 'proxy.load')) || node['opsworks_java']['tomcat']['apache_tomcat_bind_mod'] !~ /\Aproxy/
  end
end

execute 'enable module for apache-tomcat binding' do
  command "/usr/sbin/a2enmod #{node['opsworks_java']['tomcat']['apache_tomcat_bind_mod']}"
  not_if {::File.symlink?(::File.join(node['apache']['dir'], 'mods-enabled', "#{node['opsworks_java']['tomcat']['apache_tomcat_bind_mod']}.load"))}
end

execute 'enable module for apache-tomcat binding' do
  command "/usr/sbin/a2enmod proxy_balancer"
  not_if {::File.symlink?(::File.join(node['apache']['dir'], 'mods-enabled', "proxy_balancer.load"))}
end

execute 'enable module for apache-tomcat binding' do
  command "/usr/sbin/a2enmod proxy_connect"
  not_if {::File.symlink?(::File.join(node['apache']['dir'], 'mods-enabled', "proxy_connect.load"))}
end

execute 'enable module for apache-tomcat binding' do
  command "/usr/sbin/a2enmod proxy_ftp"
  not_if {::File.symlink?(::File.join(node['apache']['dir'], 'mods-enabled', "proxy_ftp.load"))}
end

execute 'enable module for apache-tomcat binding' do
  command "/usr/sbin/a2enmod proxy_http"
  not_if {::File.symlink?(::File.join(node['apache']['dir'], 'mods-enabled', "proxy_http.load"))}
end



