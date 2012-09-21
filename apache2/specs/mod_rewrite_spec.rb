require 'minitest/spec'

describe_recipe 'apache2::mod_rewrite' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_rewrite' do
    link("#{node[:apache][:dir]}/mods-enabled/rewrite.load").must_exist
  end
end
