Testing the cookbook
====================

Contributions to this cookbook will only be accepted if all tests pass successfully:

* Ruby syntax/lint checks: [RuboCop](http://batsov.com/rubocop/)
* Chef syntax/lint checks: [Foodcritic](http://acrmp.github.io/foodcritic/)
* Unit tests: [ChefSpec](http://code.sethvargo.com/chefspec/)
* Integration tests: [Test Kitchen](http://kitchen.ci/)

Setting up the test environment
-------------------------------

Install the latest version of [Vagrant](http://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (free) or [VMWare Fusion](http://www.vmware.com/products/fusion) (paid).

Clone the latest version of the cookbook from the repository.

    git clone git@github.com:escapestudios-cookbooks/newrelic.git
    cd newrelic

Install the gems used for testing:

    bundle install

Install the berkshelf plugin for vagrant:

    vagrant plugin install vagrant-berkshelf

Running syntax/lint checks
--------------------------

    bundle exec rake lint

Running unit tests
------------------

    bundle exec rake unit

Running integration tests
-------------------------

    bundle exec rake integration

Running all checks/tests
------------------------

    bundle exec rake