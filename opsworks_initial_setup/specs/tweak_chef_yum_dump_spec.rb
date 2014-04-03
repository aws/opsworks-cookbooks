require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::tweak_chef_yum_dump' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'sets lock timeout in Chef\'s yum-dump.py' do
    skip unless node[:platform] == 'amazon' && node[:opsworks][:instance][:instance_type] == 't1.micro'
    assert system("grep -i '^lock_timeout = #{node[:opsworks_initial_setup][:yum_dump_lock_timeout]}$' #{node[:opsworks_initial_setup][:yum_dump_file]}")
  end
end
