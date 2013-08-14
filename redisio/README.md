Description
===========

Website:: https://github.com/brianbianco/redisio

Installs and configures Redis server instances

Requirements
============

This cookbook builds redis from source, so it should work on any architecture for the supported distributions.  Init scripts are installed into /etc/init.d/
It depends on the ulimit cookbook: https://github.com/bmhatfield/chef-ulimit

Platforms
---------

* Debian, Ubuntu
* CentOS, Red Hat, Fedora, Scientific Linux

Tested on:

* Ubuntu 10.10, 12.04
* Debian 6.0
* Fedora 16
* Scientific Linux 6.2
* Centos 6.2, 6.3

Usage
=====

The redisio cookbook contains an LWRP for installing and uninstalling redis. It also contains 6 recipes for installation and usage of redis.

The install recipe will build, compile, install and configure redis as well as setup service resources for it.  These resources will be named for the port of the redis server, unless a "name" attribute was specified.  Example names would be: service["redis6379"] or service["redismaster"] if the name attribute was "master"

The most common use case for the redisio cookbook is to use the install recipe followed by the enable recipe.  

Another common use case is to use the install recipe, and then call the service resources created by it from another cookbook.  

It is important to note that changing the configuration options of redis does not make them take effect on the next chef run.  Due to how redis works, you cannot reload a configuration without restarting the redis service.  Redis does not offer a reload option, in order to have new options be used redis must be stopped and started. 

You should make sure to set the ulimit for the user you want to run redis as to be higher than the max connections you allow.

The disable recipe just stops redis and removes it from run levels.

The uninstall recipe, and LWRP are used to remove the configuration files and redis binaries.  This is not commonly used and may be removed in future releases.

The cookbook also contains a recipe to allow for the installation of the redis ruby gem. 

Recipes
-------

* default - This is used to install the pre-requisites for building redis, and to make the LWRPs available
* disable - This recipe can be used to disable the redis service and remove it from runlevels
* enable - This recipe can be used to enable the redis services and add it to runlevels
* install - This recipe is used to install AND configure redis.  The name is a little misleading, sorry :)
* redis_gem - This recipe can be used to install the redis ruby gem
* uninstall - This recipe can be used to remove the configuration files and redis binaries

Role File Examples
------------------

#### Install redis and setup an instance with default settings on default port, and start the service through a role file #

```ruby
run_list *%w[
  recipe[redisio::install]
  recipe[redisio::enable]
]

default_attributes({})
```

#### Install redis, give the instance a name, and use a unix socket #

```ruby
run_list *%w[
  recipe[redisio::install]
  recipe[redisio::enable]
]

default_attributes({
  'redisio' => {
    'servers' => [
      {'name' => 'master', 'port' => '6379', 'unixsocket' => '/tmp/redis.sock', 'unixsocketperm' => '755'},
    ]
  }
})
```

#### Install redis and setup two instances on the same server, on different ports, with one slaved to the other through a role file #

```ruby
run_list *%w[
  recipe[redisio::install]
  recipe[redisio::enable]
]

default_attributes({
  'redisio' => {
    'servers' => [
      {'port' => '6379'},
      {'port' => '6380', 'slaveof' => { 'address' => '127.0.0.1', 'port' => '6379' }}
    ]
  }
})
```

#### Install redis and setup two instances, on the same server, on different ports, with the default data directory changed to /mnt/redis, and the second instance named#

```ruby
run_list *%w[
  recipe[redisio::install]
  recipe[redisio::enable]
]

default_attributes({
  'redisio' => {
    'default_settings' => {'datadir' => '/mnt/redis'},
    'servers' => [{'port' => '6379'}, {'port' => '6380', 'name' => "MyInstance"}]
  }
})
```

#### Install redis and setup three instances on the same server, changing the default data directory to /mnt/redis, each instance will use a different backup type, and one instance will use a different data dir #

```ruby
run_list *%w[
  recipe[redisio::install]
  recipe[redisio::enable]
]

default_attributes({
  'redisio' => {
    'default_settings' => { 'datadir' => '/mnt/redis/'},
    'servers' => [
      {'port' => '6379','backuptype' => 'aof'},
      {'port' => '6380','backuptype' => 'both'}
      {'port' => '6381','backuptype' => 'rdb', 'datadir' => '/mnt/redis6381'}
    ]
  }
})
```

#### Install redis 2.4.11 (lower than the default version) and turn safe install off, for the event where redis is already installed.  This will use the default settings.  Keep in mind the redis version will not actually be updated until you restart the service (either through the LWRP or manually). #

```ruby
run_list *%w[
  recipe[redisio::install]
  recipe[redisio::enable]
]

default_attributes({
  'redisio' => {
    'safe_install' => false,
    'version'      => '2.4.11'
  }
})
```

#### Install version 2.2.2 of the redis ruby gem, if you don't list the version, it will simply install the latest available. #

```ruby
run_list *%w[
  recipe[redisio::redis_gem]
]

default_attributes({
  'redisio' => {
    'gem' => {
      'version' => '2.2.2'
    }
  }
})
```

LWRP Examples
-------------

Instead of using my provided recipes, you can simply include the redisio default in your role and use the LWRP's yourself.  I will show a few examples of ways to use the LWRPS, detailed breakdown of options are below
in the resources/providers section

install resource
----------------

It is important to note that this call has certain expectations for example, it expects the redis package to be in the format `redis-VERSION.tar.gz'.  The servers resource expects an array of hashes where each hash is required to contain at a key-value pair of 'port' => '<port numbers>'.

```ruby
redisio_install "redis-servers" do
  version '2.6.9'
  download_url 'http://redis.googlecode.com/files/redis-2.6.9.tar.gz'
  default_settings node['redisio']['default_settings']
  servers node['redisio']['servers']
  safe_install false
  base_piddir node['redisio']['base_piddir']
end
```

uninstall resource
------------------

I generally don't recommend using this LWRP or recipe at all, but in the event you really want to remove files, these are available.


This will only remove the redis binary files if they exist, nothing else.

```ruby
redisio_uninstall "redis-servers" do
  action :run
end
```

This will remove the redis binaries, as well as the init script and configuration files for the specified server. This will not remove any data files

```ruby
redisio_uninstall "redis-servers" do
  servers [{'port' => '6379'}]
  action :run
end
```

service resource
----------------

The install recipe sets up a service resource for each redis instance.  In the past there was a custom service LWRP called "redisio_service".  This is deprecated and should no longer be used.
I have left the resource available so as to not break it for anybody who happens to be calling it themselves from other cookbooks. 

The service resources created will use the 'name' attribute if it is specified, and will default to the port as it's name if no name is given.

Using the service resources:

```ruby
service "redis6379" do
  action :start
end
```

Or if you have named your server "Master"

```ruby
service "redisMaster" do
  action :start
end
```

Attributes
==========

Configuration options, each option corresponds to the same-named configuration option in the redis configuration file;  default values listed

* `redisio['mirror']` - mirror server with path to download redis package, default is https://redis.googlecode.com/files
* `redisio['base_name']` - the base name of the redis package to be downloaded (the part before the version), default is 'redis-'
* `redisio['artifact_type']` - the file extension of the package.  currently only .tar.gz and .tgz are supported, default is 'tar.gz'
* `redisio['version']` - the version number of redis to install (also appended to the `base_name` for downloading), default is '2.6.10'
* `redisio['safe_install'] - prevents redis from installing itself if another version of redis is installed, default is true
* `redisio['base_piddir'] - This is the directory that redis pidfile directories and pidfiles will be placed in.  Since redis can run as non root, it needs to have proper
                           permissions to the directory to create its pid.  Since each instance can run as a different user, these directories will all be nested inside this base one.

Default settings is a hash of default settings to be applied to to ALL instances.  These can be overridden for each individual server in the servers attribute.  If you are going to set logfile to a specific file, make sure to set syslog-enabled to no.

* `redisio['default_settings']` - { 'redis-option' => 'option setting' }

Available options and their defaults

```
'user'                   => 'redis' - the user to own the redis datadir, redis will also run under this user
'group'                  => 'redis' - the group to own the redis datadir
'homedir'                => Home directory of the user. Varies on distribution, check attributes file 
'shell'                  => Users shell. Varies on distribution, check attributes file
'systemuser'             => true - Sets up the instances user as a system user
'ulimit'                 => 0 - 0 is a special value causing the ulimit to be maxconnections +32.  Set to nil or false to disable setting ulimits
'configdir'              => '/etc/redis' - configuration directory
'name'                   => nil, Allows you to name the server with something other than port.  Useful if you want to use unix sockets
'address'                => nil,
'databases'              => '16',
'backuptype'             => 'rdb',
'datadir'                => '/var/lib/redis',
'unixoscket'             => nil - The location of the unix socket to use,
'unixsocketperm'         => nil - The permissions of the unix socket,
'timeout'                => '0',
'loglevel'               => 'verbose',
'logfile'                => nil,
'syslogenabled'         => 'yes',
'syslogfacility         => 'local0',
'save'                   => nil, - This attribute is nil but defaults to ['900 1','300 10','60 10000'], if you want to disable saving use an empty string 
'slaveof'                => nil,
'job_control'            => 'initd', - options are 'initd' and 'upstart'
'masterauth'             => nil,
'slaveservestaledata'    => 'yes',
'replpingslaveperiod'    => '10',
'repltimeout'            => '60',
'requirepass'            => nil,
'maxclients'             => '10000',
'maxmemory'              => nil, - This allows the use of percentages, you must append % to the number.
'maxmemorypolicy'        => 'volatile-lru',
'maxmemorysamples'       => '3',
'appendfsync'            => 'everysec',
'noappendfsynconrewrite' => 'no',
'aofrewritepercentage'   => '100',
'aofrewriteminsize'      => '64mb',
'includes'               => nil
```

* `redisio['servers']` - An array where each item is a set of key value pairs for redis instance specific settings.  The only required option is 'port'.  These settings will override the options in 'default_settings', if it is left empty it will default to [{'port' => '6379'}]

The redis_gem recipe  will also allow you to install the redis ruby gem, these are attributes related to that, and are in the redis_gem attributes file.

* `redisio['gem']['name']` - the name of the gem to install, defaults to 'redis'  
* `redisio['gem']['version']` -  the version of the gem to install.  if it is nil, the latest available version will be installed.

Resources/Providers
===================

This cookbook contains 2 LWRP's, and service resources for each instance of redis.

`service`
---------

Actions:

* `start`
* `stop`
* `restart`
* `enable`
* `disable`

Simply provide redis<server_name> where server name is the port if you haven't given it a name.

```ruby
service "redis<server_name>" do
  action [:start,:stop,:restart,:enable,:disable]
end
```

`install`
--------

Actions:

* `run` - perform the install (default)
* `nothing` - do nothing

Attribute Parameters

* `version` - the version of redis to download / install
* `download_url` - the URL plus filename of the redis package to install
* `download_dir` - the directory to store the downloaded package
* `artifact_type` - the file extension of the package
* `base_name` - the name of the package minus the extension and version number
* `user` - the user to run redis as, and to own the redis files
* `group` - the group to own the redis files
* `default_settings` - a hash of the default redis server settings
* `servers` - an array of hashes containing server configurations overrides (port is the only required)
* `safe_install` - a true or false value which determines if a version of redis will be installed if one already exists, defaults to true

This resource expects the following naming conventions:

package file should be in the format <base_name><version_number>.<artifact_type>

package file after extraction should be inside of the directory <base_name><version_number>

```ruby
install "redis" do
  action [:run,:nothing]
end
```

`uninstall`
----------

Actions:

* `run` - perform the uninstall
* `nothing` - do nothing (default)

Attribute Parameters

* `servers` - an array of hashes containing the port number of instances to remove along with the binarires.  (it is fine to pass in the same hash you used to install, even if there are additional
              only the port is used)

```ruby
uninstall "redis" do
  action [:run,:nothing]
end
```

License and Author
==================

Author:: [Brian Bianco] (<brian.bianco@gmail.com>)
Author\_Website:: http://www.brianbianco.com
Twitter:: @brianwbianco
IRC:: geekbri on freenode

Copyright 2013, Brian Bianco

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

