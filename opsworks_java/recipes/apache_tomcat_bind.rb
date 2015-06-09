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

bash "Enable selinux http_port_t target for tomcat port" do
  context = "http_port_t"
  user "root"
  code <<-EOH
    semanage port --modify --type #{context} --proto tcp #{node["opsworks_java"]["tomcat"]["port"]}
  EOH
  not_if { OpsWorks::ShellOut.shellout("/usr/sbin/semanage port -l") =~ /#{context}\s+tcp\s+#{node["opsworks_java"]["tomcat"]["port"]}/ }
  only_if { platform_family?("rhel") && ::File.exist?("/usr/sbin/getenforce") && OpsWorks::ShellOut.shellout("/usr/sbin/getenforce").strip == "Enforcing" }
end
