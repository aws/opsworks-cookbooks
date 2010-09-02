

template "/etc/sysctl.d/70-scalarium-defaults.conf" do
  mode 0644
  owner "root"
  group "root"
  source "sysctl.conf.erb"
  cookbook "scalarium_initial_setup"
end

node[:scalarium_initial_setup][:sysctl].each do |systcl, value|
  execute "Setting sysctl: #{systcl}" do
    command "sysctl -w #{systcl}=#{value}"
    action :run
  end
end