template "/etc/logrotate.d/apache2" do
  case node[:platform]
  when 'debian','ubuntu'
    path "/etc/logrotate.d/apache2"
  when 'centos','redhat','amazon','fedora','scientific','oracle'
    path "/etc/logrotate.d/httpd"
  end
  backup false
  source "logrotate.erb"
  owner "root"
  group "root"
  mode 0644
end
