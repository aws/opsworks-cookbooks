require 'minitest/spec'

describe_recipe 'apache2::mod_authz_groupfile' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_authz_groupfile' do
    link("#{node[:apache][:dir]}/mods-enabled/authz_groupfile.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/authz_groupfile.load")
  end
end
