service 'mysql' do
  service_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'mysqld'},
    'default' => 'mysql'
  )
  if platform?('ubuntu') && node[:platform_version].to_f >= 10.04
      provider Chef::Provider::Service::Upstart
  end
  supports :status => true, :restart => true, :reload => true
  action :nothing
end
