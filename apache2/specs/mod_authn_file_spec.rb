require 'minitest/spec'

describe_recipe 'apache2::mod_authn_file' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_authn_file' do
    link("#{node[:apache][:dir]}/mods-enabled/authn_file.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/authn_file.load")
  end
end
