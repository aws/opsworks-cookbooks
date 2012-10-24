require 'minitest/spec'

describe_recipe 'apache2::mod_status' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_status' do
    link("#{node[:apache][:dir]}/mods-enabled/status.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/status.load")
  end
end
