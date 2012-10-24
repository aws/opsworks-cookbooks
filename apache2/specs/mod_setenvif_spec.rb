require 'minitest/spec'

describe_recipe 'apache2::mod_setenvif' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_setenvif' do
    link("#{node[:apache][:dir]}/mods-enabled/setenvif.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/setenvif.load")
  end
end
