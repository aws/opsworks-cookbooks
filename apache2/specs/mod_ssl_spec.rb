require 'minitest/spec'

describe_recipe 'apache2::mod_ssl' do
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

  it 'dependencies installed and clean configuration on rhel platform family' do
    if node[:platform_family] == 'rhel'
      package('mod_ssl').must_be_installed
      file("#{node[:apache][:dir]}/conf.d/ssl.conf").wont_exist
    end
  end

  it 'creates ports.conf' do
    file("#{node[:apache][:dir]}/ports.conf").must_exist.with(:owner, 'root').and(
         :group, 'root').and(:mode, '644')
  end

  it 'enables mod_ssl' do
    link("#{node[:apache][:dir]}/mods-enabled/ssl.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{@prefix}/mods-available/ssl.load")
  end
end
