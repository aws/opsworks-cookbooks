require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::swap' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it "creates and enables a swapfile" do
    skip unless node['opsworks_initial_setup']['swapfile_instancetypes'].include?(node[:ec2][:instance_type])

    file(
      node['opsworks_initial_setup']['swapfile_name']
    ).must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '0600')
    file("/proc/swaps").must_match(/^#{node['opsworks_initial_setup']['swapfile_name']}/)
  end

  it "does not create swapfile on larger instances" do
    skip if node['opsworks_initial_setup']['swapfile_instancetypes'].include?(node[:ec2][:instance_type])
    file(node['opsworks_initial_setup']['swapfile_name']).wont_exist
  end
end
