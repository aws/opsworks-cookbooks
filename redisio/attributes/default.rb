# Cookbook Name:: redisio
# Attribute::default
#
# Copyright 2013, Brian Bianco <brian.bianco@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform']
when 'ubuntu','debian'
  shell = '/bin/false'
  homedir = '/var/lib/redis'
when 'centos','redhat','scientific','amazon','suse'
  shell = '/bin/sh'
  homedir = '/var/lib/redis'
when 'fedora'
  shell = '/bin/sh'
  homedir = '/home' #this is necessary because selinux by default prevents the homedir from being managed in /var/lib/
else
  shell = '/bin/sh'
  homedir = '/redis'
end

#Install related attributes
default['redisio']['safe_install'] = true

#Tarball and download related defaults
default['redisio']['mirror'] = "https://redis.googlecode.com/files"
default['redisio']['base_name'] = 'redis-'
default['redisio']['artifact_type'] = 'tar.gz'
default['redisio']['version'] = '2.6.11'
default['redisio']['base_piddir'] = '/var/run/redis'

#Default settings for all redis instances, these can be overridden on a per server basis in the 'servers' hash
default['redisio']['default_settings'] = {
  'user'                   => 'redis',
  'group'                  => 'redis',
  'homedir'                => homedir,
  'shell'                  => shell,
  'systemuser'             => true,
  'ulimit'                 => 0,
  'configdir'              => '/etc/redis',
  'name'                   => nil,
  'address'                => nil,
  'databases'              => '16',
  'backuptype'             => 'rdb',
  'datadir'                => '/var/lib/redis',
  'unixsocket'             => nil,
  'unixsocketperm'         => nil,
  'timeout'                => '0',
  'loglevel'               => 'verbose',
  'logfile'                => nil,
  'syslogenabled'          => 'yes',
  'syslogfacility'         => 'local0',
  'shutdown_save'          => false,
  'save'                   => nil, # Defaults to ['900 1','300 10','60 10000'] inside of template.  Needed due to lack of hash subtraction
  'slaveof'                => nil,
  'job_control'            => 'initd',
  'masterauth'             => nil,
  'slaveservestaledata'    => 'yes',
  'replpingslaveperiod'    => '10',
  'repltimeout'            => '60',
  'requirepass'            => nil,
  'maxclients'             => 10000,
  'maxmemory'              => nil,
  'maxmemorypolicy'        => 'volatile-lru',
  'maxmemorysamples'       => '3',
  'appendfsync'            => 'everysec',
  'noappendfsynconrewrite' => 'no',
  'aofrewritepercentage'   => '100',
  'aofrewriteminsize'      => '64mb',
  'includes'               => nil
}

# The default for this is set inside of the "install" recipe. This is due to the way deep merge handles arrays
default['redisio']['servers'] = nil

