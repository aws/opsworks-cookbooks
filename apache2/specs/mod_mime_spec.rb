require 'minitest/spec'

describe_recipe 'apache2::mod_mime' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'enables mod_mime' do
    skip('"to" is always evaluated falsely - bug with old minitest-chef-handler version?') if ['debian','ubuntu'].include?(node[:platform])
    link("#{node[:apache][:dir]}/mods-enabled/mime.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/mime.load")
  end
end
