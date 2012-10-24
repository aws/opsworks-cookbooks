require 'minitest/spec'

describe_recipe 'apache2::mod_fcgid' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_fcgid' do
    link("#{node[:apache][:dir]}/mods-enabled/fcgid.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/fcgid.load")
  end
end
