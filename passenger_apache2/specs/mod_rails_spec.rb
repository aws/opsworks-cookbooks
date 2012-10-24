require 'minitest/spec'

describe_recipe 'passenger_apache2::mod_rails' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs mod_passenger' do
    skip unless ['centos','redhat','amazon'].include?(node[:platform]) && node[:packages][:dist_only]
    package('mod_passenger').must_be_installed
  end

  it 'removes mod_passenger.conf' do
    skip unless ['centos','redhat','amazon'].include?(node[:platform]) && node[:packages][:dist_only]
    file(File.join(node[:apache][:dir], 'conf.d', 'mod_passenger.conf')).wont_exist
  end

  it 'creates passenger.load' do
    skip if ['centos','redhat','amazon'].include?(node[:platform]) && node[:packages][:dist_only]
    file(File.join(node[:apache][:dir], 'mods-available', 'passenger.load')).must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '644')
  end

  it 'creates passenger.conf' do
    file(File.join(node[:apache][:dir], 'mods-available', 'passenger.conf')).must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '644')
  end

  it 'enables mod_passenger' do
    link(File.join(node[:apache][:dir], 'mods-enabled', 'passenger.load')).must_exist
  end
end
