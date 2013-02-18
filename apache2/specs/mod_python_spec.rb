require 'minitest/spec'

describe_recipe 'apache2::mod_python' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs dependencies' do
    case node[:platform]
    when 'debian','ubuntu'
      package('libapache2-mod-python').must_be_installed
    when 'centos','redhat','fedora','amazon'
      package('mod_python').must_be_installed
    end
  end

  it 'enables mod_python' do
    link("#{node[:apache][:dir]}/mods-enabled/python.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/python.load")
  end
end
