require 'minitest/spec'

describe_recipe 'apache2::mod_negotiation' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_negotiation' do
    link("#{node[:apache][:dir]}/mods-enabled/negotiation.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/negotiation.load")
  end
end
