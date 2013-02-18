require 'minitest/spec'

describe_recipe 'apache2::mod_rewrite' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_rewrite' do
    link("#{node[:apache][:dir]}/mods-enabled/rewrite.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/rewrite.load")
  end
end
