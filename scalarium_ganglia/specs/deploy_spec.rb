require 'minitest/spec'

describe_recipe 'scalarium_ganglia::deploy' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates events directory' do
    directory(node[:ganglia][:events_dir]).must_exist.with(:mode, '755').and(:owner, node[:ganglia][:web][:apache_user])
  end

  it 'creates event json' do
    file(File.join(node[:ganglia][:events_dir], "#{node[:scalarium][:sent_at]}_event.json")).must_exist.with(:mode, '644').and(:owner, node[:ganglia][:web][:apache_user])
  end
end
