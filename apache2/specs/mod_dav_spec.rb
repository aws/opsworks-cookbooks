require 'minitest/spec'

describe_recipe 'apache2::mod_dav' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_dav' do
    link("#{node[:apache][:dir]}/mods-enabled/dav.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/dav.load")
  end
end
