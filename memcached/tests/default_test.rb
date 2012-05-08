# test the memcached installation/service
require 'memcached'

class MemcacheTest < MiniTest::Chef::TestCase
 
  def test_exist_service_configuration_file
    assert File.read('/etc/default/memcached')
  end

  def test_exist_monit_configuration_file
    assert File.read('/etc/monit/conf.d/memcached.monitrc')
  end

  def test_service_started
    assert service("memcached").must_be_running
  end

  def test_tcp_access_to_server
   assert TCPSocket.new('127.0.0.1', '<%=port%>') rescue puts "Memcached is not accepting connections on 127.0.0.1:<%=port%>"
   assert TCPSocket.new('localhost', '<%=port%>') rescue puts "Memcached is not accepting connections on localhost:<%=port%>"
   assert TCPSocket.new("#{node['instance']['private_ip']}", "<%=port%>") rescue puts "Memcached is not accepting connections on #{node['instance']['private_ip']}:<%=port%>"
  end

  def test_access_service  
    %w{127.0.0.1  localhost  #{node['instance']['private_ip']}}.each do |host|
      m = Memcached.new(["#{host}:<%=port%>"])
      #test different types of data
      key1 = 'foo'
      key2 = 'bar'*50
      key3 = '£∞'*50
      value1 = 'abc'
      value2 = 'xyz'*1000
      value3 = '∞§¶•ª'*1000

      10.times do
        assert_equal "STORED\r\n", m.set(key1, value1)
        assert_equal "STORED\r\n", m.set(key2, value2)
        assert_equal "STORED\r\n", m.set(key3, value3)
        assert_equal value1, m.get(key1)
        assert_equal value2, m.get(key2)
        assert_equal value3, m.get(key3)
        assert_equal "DELETED\r\n", m.delete(key1)
        assert_equal "STORED\r\n", m.set(key1, value2)
        assert_equal value2, m.get(key1)
        assert_equal "STORED\r\n", m.set(key2, value3)
        assert_equal value3, m.get(key2)
        assert_equal "STORED\r\n", m.set(key3, value1)
        assert_equal value1, m.get(key3)
      end
      rescue Exception => exp
        puts exp.message
        ex = exp
      end
  end

end
