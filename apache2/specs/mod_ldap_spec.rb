require 'minitest/spec'

describe_recipe 'apache2::mod_ldap' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_ldap' do
    link("#{node[:apache][:dir]}/mods-enabled/ldap.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/ldap.load")
  end
end
