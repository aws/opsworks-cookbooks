require 'minitest/spec'

describe_recipe 'apache2::mod_proxy_http' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_proxy_http' do
    link("#{node[:apache][:dir]}/mods-enabled/proxy_http.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/proxy_http.load")
  end
end
