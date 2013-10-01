require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::tweak_chef_yum_dump' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'sets lock timeout in Chef\'s yum-dump.py' do
    skip unless node[:platform] == 'amazon' && node[:opsworks][:instance][:instance_type] == 't1.micro'
    assert system("grep '^lock_timeout = #{node[:opsworks_initial_setup][:micro][:yum_dump_lock_timeout]}$' #{node[:opsworks_agent][:current_dir]}/vendor/bundle/ruby/1.8/gems/chef-0.9.15.5/lib/chef/provider/package/yum-dump.py")
  end
end
