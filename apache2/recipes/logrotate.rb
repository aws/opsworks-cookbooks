template '/etc/logrotate.d/apache2' do
  case node[:platform_family]
  when 'debian'
    path '/etc/logrotate.d/apache2'
  when 'rhel'
    path '/etc/logrotate.d/httpd'
  end
  backup false
  source 'logrotate.erb'
  owner 'root'
  group 'root'
  mode 0644
end
