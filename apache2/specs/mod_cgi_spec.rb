require 'minitest/spec'

describe_recipe 'apache2::mod_cgi' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_cgi' do
    link("#{node[:apache][:dir]}/mods-enabled/cgi.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/cgi.load")
  end
end
