require 'minitest/spec'

describe_recipe 'nginx::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates nginx directory' do
    directory(node[:nginx][:dir]).must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
  end

  it 'creates log directory' do
    directory(node[:nginx][:log_dir]).must_exist.with(:owner, node[:nginx][:user]).and(:mode, '755')
  end

  it 'creates debian style nginx site directories' do
    %w{sites-available sites-enabled conf.d}.each do |dir|
      directory(File.join(node[:nginx][:dir], dir)).must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '755')
    end
  end

  it 'creates debian style nginx site enabling/disabling scripts' do
    %w{nxensite nxdissite}.each do |nxscript|
      file("/usr/sbin/#{nxscript}").must_exist.with(:mode, '755').and(:owner, 'root').and(:group, 'root')
    end
  end

  it 'creates nginx conf file' do
    file(File.join(node[:nginx][:dir], 'nginx.conf')).must_exist.with(:owner, 'root').and(:group, 'root').and(:mode, '644')
  end

  it 'creates default site' do
    file(File.join(node[:nginx][:dir], 'sites-available', 'default')).must_exist.with(:mode, '644').and(:owner, 'root').and(:group, 'root')
  end

  it 'enables nginx service' do
    service('nginx').must_be_enabled
  end

  it 'starts nginx service' do
    service('nginx').must_be_running
  end
end
