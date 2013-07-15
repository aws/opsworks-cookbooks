require 'minitest/spec'

describe_recipe 'haproxy::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs haproxy' do
    package('haproxy').must_be_installed
  end

  it 'sets up /etc/default/haproxy for only debian based systems' do
    case node[:platform]
    when "debian","ubuntu"
      file('/etc/default/haproxy').must_exist.with(:mode, '644').and(:owner, 'root').and(:group, 'root')
    else
      file('/etc/default/haproxy').wont_exist
    end
  end

  it 'enables and starts haproxy' do
#    service('haproxy').must_be_enabled
    assert system("rpm -qa | grep haproxy")
    service('haproxy').must_be_running
  end

  it 'creates haproxy.cfg' do
    file('/etc/haproxy/haproxy.cfg').must_exist.with(:mode, '644').and(:owner, 'root').and(:group, 'root')
  end

  it 'sets up configuration' do
    file('/etc/haproxy/haproxy.cfg').must_include node[:haproxy][:global_max_connections]
    file('/etc/haproxy/haproxy.cfg').must_include node[:haproxy][:default_max_connections]
    file('/etc/haproxy/haproxy.cfg').must_include node[:haproxy][:client_timeout]
    file('/etc/haproxy/haproxy.cfg').must_include node[:haproxy][:server_timeout]
    file('/etc/haproxy/haproxy.cfg').must_include node[:haproxy][:queue_timeout]
    file('/etc/haproxy/haproxy.cfg').must_include node[:haproxy][:connect_timeout]
    file('/etc/haproxy/haproxy.cfg').must_include node[:haproxy][:http_request_timeout]
    if node[:haproxy][:enable_stats]
      file('/etc/haproxy/haproxy.cfg').must_include node[:haproxy][:stats_user]
      file('/etc/haproxy/haproxy.cfg').must_include node[:haproxy][:stats_password]
      file('/etc/haproxy/haproxy.cfg').must_include node[:haproxy][:stats_url]
    end
  end
end
