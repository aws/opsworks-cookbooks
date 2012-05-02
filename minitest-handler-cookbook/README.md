Cookbook: minitest-handler  
Author: Bryan McLellan <btm@loftninjas.org>  
Copyright: 2012 Opscode, Inc.  
License: Apache 2.0  

Description
===========

This cookbook utilizes the minitest-chef-handler project to facilitate cookbook testing.

minitest-chef-handler project: https://github.com/calavera/minitest-chef-handler  
stable minitest-handler cookbook: http://community.opscode.com/cookbooks/minitest-handler  
minitest-handler cookbook development: https://github.com/btm/minitest-handler-cookbook  

Attributes
==========

node[:minitest][:path] - Location to store and find tests

Usage
=====

* The node run list should begin with 'recipe[chef-minitest]'
* Each cookbook should contain tests in the 'files/default/tests/minitest' directory with a file suffix of '_test.rb'

Minitest: https://github.com/seattlerb/minitest

Example
=====

    class TestApache2 < MiniTest::Chef::TestCase
      def test_that_the_package_installed
        case node[:platform]
        when "ubuntu","debian"
          assert system('apt-cache policy apache2 | grep Installed | grep -v none')
        end
      end
    
      def test_that_the_service_is_running
        assert system('/etc/init.d/apache2 status')
      end
    
      def test_that_the_service_is_enabled
        assert File.exists?(Dir.glob("/etc/rc5.d/S*apache2").first)
      end
    end

Changelog
=====

### v0.0.5 

* Install the minitest-chef-handler gem instead of downloading from github directly
* Remove tests from cookbooks no longer in the run list

### v0.0.4

Add examples/ top level directory (may not work)
