require 'minitest/spec'

describe_recipe 'apache2::mod_dav_svn' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs svn dependencies' do
    case node[:platform]
    when 'centos','redhat','fedora','amazon'
      package('mod_dav_svn').must_be_installed
    when 'debian','ubuntu'
      package('libapache2-svn').must_be_installed
    end
  end

  it 'enables mod_dav_svn' do
    link("#{node[:apache][:dir]}/mods-enabled/dav_svn.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{node[:apache][:dir]}/mods-available/dav_svn.load")
  end
end
