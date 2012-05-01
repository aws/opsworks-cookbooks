class DhTest < MiniTest::Chef::TestCase
    def test_exist_configuration_file
          assert File.read('/etc/memcached.conf')
          #.include?('scalarium-agent ALL=NOPASSWD:/opt/scalarium-agent/bin/chef-solo'), 'allow scalarium-agent user to run chef-solo with sudo'
    end
end
