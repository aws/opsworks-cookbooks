require 'minitest/spec'

describe_recipe 'opsworks_ganglia::deploy' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates events directory' do
    directory(
      node[:ganglia][:events_dir]
    ).must_exist.with(:mode, '755').and(:owner, node[:apache][:user])
  end

  it 'creates event json' do
    file(
      ::File.join(node[:ganglia][:events_dir], "#{node[:opsworks][:sent_at]}_event.json")
    ).must_exist.with(:mode, '644').and(:owner, node[:apache][:user])
  end
end
