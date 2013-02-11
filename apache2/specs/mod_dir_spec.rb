require 'minitest/spec'

describe_recipe 'apache2::mod_dir' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_dir' do
    link("#{node[:apache][:dir]}/mods-enabled/dir.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/dir.load")
  end
end
