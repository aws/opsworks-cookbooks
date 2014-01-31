service 'wildfly' do
  service_name node['opsworks_java']['wildfly']['service_name']

  case node[:platform_family]
    when 'debian'
      supports :restart => true, :reload => false, :status => true
    when 'rhel'
      supports :restart => true, :reload => true, :status => true
  end

  action :nothing
end

cookbook_file "/tmp/wildfly-service.sh" do
  source "service.sh.erb"
  mode 0755
end

execute "install wildly service" do
  user "root"
  command "sh /tmp/wildfly-service.sh"
  notifies :start, "service[wildfly]"
end
