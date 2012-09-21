require 'minitest/spec'

describe_recipe 'apache2::mod_auth_basic' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_auth_basic' do
    link("#{node[:apache][:dir]}/mods-enabled/auth_basic.load").must_exist
  end
end
