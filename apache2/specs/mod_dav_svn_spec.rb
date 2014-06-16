require 'minitest/spec'

describe_recipe 'apache2::mod_dav_svn' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  before :all do
    @prefix = case node[:platform_family]
              when 'rhel'
                node[:apache][:dir]
              when "debian"
                ".."
              end
  end

  it 'installs svn dependencies' do
    case node[:platform_family]
    when 'rhel'
      package('mod_dav_svn').must_be_installed
    when 'debian'
      package('libapache2-svn').must_be_installed
    end
  end

  it 'enables mod_dav_svn' do
    link("#{node[:apache][:dir]}/mods-enabled/dav_svn.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{@prefix}/mods-available/dav_svn.load")
  end
end
