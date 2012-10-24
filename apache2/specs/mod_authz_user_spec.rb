require 'minitest/spec'

describe_recipe 'apache2::mod_authz_user' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_authz_user' do
    link("#{node[:apache][:dir]}/mods-enabled/authz_user.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/authz_user.load")
  end
end
