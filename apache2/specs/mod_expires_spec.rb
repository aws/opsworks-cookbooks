require 'minitest/spec'

describe_recipe 'apache2::mod_expires' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_expires' do
    link("#{node[:apache][:dir]}/mods-enabled/expires.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/expires.load")
  end
end
