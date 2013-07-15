require 'minitest/spec'

describe_recipe 'opsworks_ganglia::views' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates conf dir' do
    directory(
      node[:ganglia][:conf_dir]
    ).must_exist.with(:mode, '755').and(:owner, node[:apache][:user])
  end

  it 'creates json files for each instance' do
    instances = {}
    node[:opsworks][:layers].each do |layer_name, layer_config|
      layer_config[:instances].each do |instance_name, instance_config|
        instances[instance_name] ||= []
        instances[instance_name] << layer_name
      end
    end

    instances.keys.each do |instance_name|
      file(
        ::File.join(node[:ganglia][:datadir], 'conf', "host_#{instance_name}.json")
      ).must_exist.with(:mode, '644').and(:owner, node[:apache][:user]).and(:group, node[:apache][:group])
    end
  end

  it 'creates view_overview json' do
    file(
      ::File.join(node[:ganglia][:datadir], 'conf', 'view_overview.json')
    ).must_exist.with(:mode, '644').and(:owner, node[:apache][:user]).and(:group, node[:apache][:group])
  end
end
