directory node[:ganglia][:conf_dir] do
  mode "0755"
  action :create
  recursive true
  owner node[:apache][:user]
  group node[:apache][:group]
end

instances = {}

node[:opsworks][:layers].each do |layer_name, layer_config|
  layer_config[:instances].each do |instance_name, instance_config|
    instances[instance_name] ||= []
    instances[instance_name] << layer_name
  end
end

# generate individual server view json
instances.keys.each do |instance_name|
  template "#{node[:ganglia][:datadir]}/conf/host_#{instance_name}.json" do
    source 'host_view_json.erb'
    mode "0644"
    owner node[:apache][:user]
    group node[:apache][:group]
    variables({:layers => instances[instance_name]})
  end
end

# generate opsworks view json for autorotation
template "#{node[:ganglia][:datadir]}/conf/view_overview.json" do
  source 'view_overview.json.erb'
  mode "0644"
  owner node[:apache][:user]
  group node[:apache][:group]
  variables({:instances => instances})
end
