directory node[:ganglia][:conf_dir] do
  mode '0755'
  action :create
  recursive true
  owner 'www-data'
end

instances = {}

node[:scalarium][:roles].each do |role_name, role_config|
  role_config[:instances].each do |instance_name, instance_config|
    instances[instance_name] ||= []
    instances[instance_name] << role_name
  end
end

# generate individual server view json
instances.keys.each do |instance_name|
  template "#{node[:ganglia][:datadir]}/conf/host_#{instance_name}.json" do
    source 'host_view_json.erb'
    mode '0644'
    owner 'www-data'
    group 'www-data'
    variables({:roles => instances[instance_name]})
  end
end

# generate scalarium view json for autorotation
template "#{node[:ganglia][:datadir]}/conf/view_overview.json" do
  source 'view_overview.json.erb'
  mode '0644'
  owner 'www-data'
  group 'www-data'
  variables({:instances => instances})
end