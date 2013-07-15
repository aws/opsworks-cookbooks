require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::autofs' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it "installs the autofs package" do
    package("autofs").must_be_installed
  end

  it "creates the opsworks autofs map file" do
    file(
      node[:opsworks_initial_setup][:autofs_map_file]
    ).must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '444')
  end

  it "ensures the opsworks autofs map file is referenced in /etc/auto.master" do
    file('/etc/auto.master').must_include "/- #{node[:opsworks_initial_setup][:autofs_map_file]}"
  end

  it "starts autofs service" do
    assert system("service autofs status")
  end

  it "should load the opsworks autofs map file in the automounter map" do
    (`automount -m`).must_include("map: #{node[:opsworks_initial_setup][:autofs_map_file]}")
  end
end
