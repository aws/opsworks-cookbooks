require 'minitest/spec'

describe_recipe 'apache2::mod_env' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_env' do
    link("#{node[:apache][:dir]}/mods-enabled/env.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/env.load")
  end
end
