Logentries_agent Chef Cookbook
==============

Installs/Configures the Logentries agent to allow logging to [Logentries](https://logentries.com)

Requirements
------------

### Platform:

* Debian
* Ubuntu
* Rhel

### Cookbooks:

The following are dependencies of the Logentries cookbook

* apt
* yum

Attributes
----------

### Default

* `node['le']['account_key']` - your Logentries account_key (this can be found following [this link](https://logentries.com/doc/accountkey/))
* `node['le']['hostname']` - sets the hostname of the log to the machine name, defaults to `node['hostname']`
* `node['le']['logs_to_follow']` - An array of logs to follow or a hash of arrays
* `node['le']['datahub']['enable']` - To send logs to datahub set this to true. Default is false
* `node['le']['datahub']['server_ip']` - IP of your datahub server
* `node['le']['datahub']['port']` - port datahub is running on, normally port 10000
* `node['le']['pull-server-side-config']` - Specifies whether to make an api call to pull configuration or not, by default this is set to true meaning an api call will be made to logentries.com. Default is true
* `node['le']['deb']` - the distro of the debian platform , defaults to node['lsb']['codename'].

### Example of logs_to_follow
* caveats - name needs to be unique

Usage
-----
There are 3 main scenarios in which the Logentries Linux Agent can be run.

#### Default (no datahub and pull configuration from logentries.com)
```ruby
override['le']['account_key'] = <logentries_account_key>
override['le']['logs_to_follow'] = ['/var/log/syslog']
override['le']['logs_to_follow'] = [{:name => 'syslog', :log => '/var/log/syslog'}]
```

This is the normal case where you send the data directly to Logentries and get the configuration for your logs from Logentries as well.
To send data to logentries you will have to override node['le']['account_key']

#### Local configuration only
```ruby
override['le']['pull-server-side-config'] = false
override['le']['logs_to_follow'] = [{:name => 'syslog', :log => '/var/log/syslog', :token => '00000000-0000-0000-0000-000000000000'}]
```
To send data to Logentries without specifying an account key, you can set override['le']['pull-server-side-config'] to false. This will only send the logs specified in the configuration file without contacting Logentries. In this case you have to create the logs in advance and know the tokens as well.


#### Datahub
```ruby
override['le']['datahub']['enable'] = true
override['le']['pull-server-side-config'] = false
override['le']['datahub']['server_ip'] = '1.2.3.4'
override['le']['datahub']['port'] = 10000
override['le']['logs_to_follow'] = [{:name => 'syslog', :log => '/var/log/syslog'}]
```
This scenario is for datahub users looking to push a config and not need to register to send their logs to their datahub instance.

Usage
-----

Put depends 'yum', and 'apt', in your metadata.rb to gain access to the resources.

Updating the Logentries Agent
=============================

Restarting the Chef script will allow the recipe to install any updates to the Logentries agent.

License and Author
------------------

* Author:: Joe Heung (<joe.heung@logentries.com>)

Copyright (C) 2015, RevelOps Inc.

License:: All rights reserved
