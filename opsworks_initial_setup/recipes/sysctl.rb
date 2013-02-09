directory "/etc/sysctl.d" do
  mode 0755
  owner "root"
  group "root"
  action :create
end

template "/etc/sysctl.d/70-opsworks-defaults.conf" do
  mode 0644
  owner "root"
  group "root"
  source "sysctl.conf.erb"
  cookbook "opsworks_initial_setup"
end

node[:opsworks_initial_setup][:sysctl].each do |systcl, value|
  execute "Setting sysctl: #{systcl}" do
    command "sysctl -w #{systcl}=#{value}"
    action :run
  end
end
