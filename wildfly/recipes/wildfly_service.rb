service 'wildfly' do
  service_name node['wildfly']['service_name']

  case node[:platform_family]
    when 'debian'
      supports :restart => true, :reload => false, :status => true
    when 'rhel'
      supports :restart => true, :reload => true, :status => true
  end

  action :nothing
end

template "/tmp/wildfly-service.sh" do
  backup false
  source "service.sh.erb"
  mode 0755
end

directory 'log-directory' do
  path '/opt/wildfly-' + node['wildfly']['version'] + '/standalone/log'
  owner 'wildfly'
  group 'wildfly'
end

directory 'data-directory' do
  path '/opt/wildfly-' + node['wildfly']['version'] + '/standalone/data'
  owner 'wildfly'
  group 'wildfly'
end

execute "install wildfly service" do
  user "root"
  command "sudo sh /tmp/wildfly-service.sh"
  :run
  notifies :start, "service[wildfly]"
end
