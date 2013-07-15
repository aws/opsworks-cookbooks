require 'minitest/spec'

describe_recipe 'memcached::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs the memcached package' do
    package('memcached').must_be_installed
  end

  it 'installs system config' do
    case node[:platform]
    when 'centos','redhat','fedora','amazon'
      file('/etc/sysconfig/memcached').must_exist
    when 'debian','ubuntu'
      file('/etc/default/memcached').must_exist
    end
  end

  it 'creates monit configuration file' do
    file("#{node[:monit][:conf_dir]}/memcached.monitrc").must_exist
  end

  it 'starts service' do
    service('memcached').must_be_running
  end

  it 'allows memcached port to be accessible on 127.0.0.1' do
    access_memcache_over_tcp('127.0.0.1')
  end

  it 'allows memcached port to be accessible on localhost' do
    access_memcache_over_tcp('localhost')
  end

  it 'allows memcached port to be accesible on private ip' do
    access_memcache_over_tcp(node[:opsworks][:instance][:private_ip])
  end

  it 'accesses service on 127.0.0.1' do
    access_memcached_service('127.0.0.1')
  end

  it 'accesses service on localhost' do
    access_memcached_service('localhost')
  end

  it 'accesses service on private ip' do
    access_memcached_service(node[:opsworks][:instance][:private_ip])
  end

  def access_memcached_service(host)
    port = node[:memcached][:port]

    m = Memcached.new(["#{host}:#{port}"], {:binary_protocol => false})

    #test different types of data. Memcached has issues with utf8 characters.
    key1 = 'foo'
    key2 = 'bar'*10
    #key3 = '£∞'
    key3 = "223FF"
    value1 = 'abc'*1000
    value2 = 'xyz'*1000
    #value3 = '∞§¶•ª'*2
    value3 = 'ERR..'

    100.times do
      assert_nil m.set(key1, value1), "STORED\r\n"
      assert_nil m.set(key2, value2), "STORED\r\n"
      assert_nil m.set(key3, value3), "STORED\r\n"
      assert_equal value1, m.get(key1)
      assert_equal value2, m.get(key2)
      assert_equal value3, m.get(key3)
      assert_nil m.delete(key1), "DELETED\r\n"
      assert_nil m.set(key1, value2), "STORED\r\n"
      assert_equal value2, m.get(key1)
      assert_nil m.set(key2, value3), "STORED\r\n"
      assert_equal value3, m.get(key2)
      assert_nil m.set(key3, value1), "STORED\r\n"
      assert_equal value1, m.get(key3)
    end
  end

  def access_memcache_over_tcp(host)
    port = "#{node[:memcached][:port]}"
    refute_nil TCPSocket.new(host, port), "Memcached is not accepting connections on #{host}:#{port}"
  end
end
