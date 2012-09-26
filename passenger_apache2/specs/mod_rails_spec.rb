require 'minitest/spec'

describe_recipe 'passenger_apache2::mod_rails' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs mod_passenger', :if => ['centos','redhat','amazon'].include?(node[:platform]) && dist_only? do
    package('mod_passenger').must_be_installed
  end

  it 'removes mod_passenger.conf', :if => ['centos','redhat','amazon'].include?(node[:platform]) && dist_only? do
    file(File.join(node[:apache][:dir], 'conf.d', 'mod_passenger.conf')).wont_exist
  end

  it 'creates passenger.load', :unless => ['centos', 'redhat', 'amazon'].include?(node[:platform]) && dist_only? do
    file(File.join(node[:apache][:dir], 'mods-available', 'passenger.load')).must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
  end

  it 'creates passenger.conf' do
    file(File.join(node[:apache][:dir], 'mods-available', 'passenger.conf')).must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
  end

  it 'enables mod_passenger' do
    link(File.join(node[:apache][:dir], 'mods-enabled', 'passenger.load')).must_exist
  end
end
