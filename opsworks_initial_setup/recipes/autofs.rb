package 'Install automounter' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'autofs'},
    ['debian','ubuntu'] => {'default' => 'autofs'}
  )
  action :install
end

service "autofs" do
  supports :status => true, :restart => false, :reload => true
  action [ :enable, :start ]
end

template '/etc/auto.opsworks' do
  source 'automount.opsworks.erb'
  mode 0444
  owner 'root'
  group 'root'
  notifies :restart, resources(:service => 'autofs'), :immediately
end

bash "Add auto.opsworks to /etc/auto.master and restart autofs" do
  code <<-EOF
    echo "/- /etc/auto.opsworks" >> /etc/auto.master
  EOF
  notifies :restart, resources(:service => 'autofs'), :immediately
  not_if { ::File.read('/etc/auto.master').include?('auto.opsworks') }
end
