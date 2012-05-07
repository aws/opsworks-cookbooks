# test the memcached installation/service

class DhTest < MiniTest::Chef::TestCase
    attr_accessor: cache

    def test_exist_configuration_file
          assert File.read('/etc/memcached.conf')
    end

    def test_exist_service_configuration_file
          assert File.read('/etc/default/memcached')
    end

    def test_exist_monit_configuration_file
          assert File.read('/etc/monit/conf.d/memcached.monitrc')
    end

    def test_live_server?
      assert TCPSocket.new('localhost', "<%=port%>") rescue puts "Memcached is not accepting connections on localhost:<%=port%>"
    end

    def test_service_running
      require 'memcached'
      @cache = Memcached.new("localhost:<%=port%>") 
      value = 'hello'
      @cache.set 'test', value
      assert @cache.get 'test' #=> "hello"  
    end

    def test_live_server  
      return puts("Skipping EventMachine test, no live server") if !test_live_server?

      require 'eventmachine'
      require 'memcache/event_machine'
      ex = nil
      within_em do
        begin
          m = MemCache.new(['127.0.0.1:<%=port%>', 'localhost:<%=port%>'])
          key1 = 'foo'
          key2 = 'bar'*50
          key3 = '£∞'*50
          value1 = 'abc'
          value2 = 'xyz'*1000
          value3 = '∞§¶•ª'*1000
      
          1000.times do
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
            assert_equal({ key1 => value2, key2 => value3, key3 => value1 }, 
                         m.get_multi(key1, key2, key3))
          end
        rescue Exception => exp
          puts exp.message
          ex = exp
        ensure
          EM.stop
        end
      end
      raise ex if ex
  end

end
