require 'minitest/spec'

describe_recipe 'apache2::mod_authz_host' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_authz_host' do
    link("#{node[:apache][:dir]}/mods-enabled/authz_host.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/authz_host.load")
  end
end
