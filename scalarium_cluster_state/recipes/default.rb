require 'resolv'

dir = File.dirname(node[:scalarium][:stack_state][:path])

directory dir do
  mode 0755
  action :create
  recursive true  
end

template node[:scalarium][:stack_state][:path] do
  source 'cluster_state.json.erb'
  mode 0644
  variables(:scalarium => node[:scalarium])
end

template '/etc/hosts' do
  source 'hosts.erb'
  mode 0644
  variables(:scalarium => node[:scalarium])
end
