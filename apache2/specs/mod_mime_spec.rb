require 'minitest/spec'

describe_recipe 'apache2::mod_mime' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_mime' do
    link("#{node[:apache][:dir]}/mods-enabled/mime.load").must_exist
  end
end
