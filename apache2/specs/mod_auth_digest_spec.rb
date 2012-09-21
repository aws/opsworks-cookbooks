require 'minitest/spec'

describe_recipe 'apache2::mod_auth_digest' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_auth_digest' do
    link("#{node[:apache][:dir]}/mods-enabled/auth_digest.load").must_exist
  end
end
