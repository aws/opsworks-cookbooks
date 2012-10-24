require 'minitest/spec'

describe_recipe 'apache2::mod_alias' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_alias' do
    link("#{node[:apache][:dir]}/mods-enabled/alias.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/alias.load")
  end
end
