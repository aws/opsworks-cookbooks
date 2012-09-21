require 'minitest/spec'

describe_recipe 'apache2::mod_log_config' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_log_config for RHEL systems' do
    if node[:platform] == 'centos' || node[:platform] == 'redhat' ||
       node[:platform] == 'fedora' || node[:platform] == 'suse' ||
       node[:platform] == 'amazon'
      link("#{node[:apache][:dir]}/mods-enabled/log_config.load").must_exist
    end
  end
end
