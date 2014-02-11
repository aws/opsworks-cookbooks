#
# Cookbook Name:: apache2
# Attributes:: apache
#
# Copyright 2008, OpsCode, Inc.
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

###
# Do not use this file to override the apache2 cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "apache2/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'apache2/attributes/apache.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

case node[:platform]
when 'redhat','centos','fedora','amazon'
  default[:apache][:dir]         = '/etc/httpd'
  default[:apache][:log_dir]     = '/var/log/httpd'
  default[:apache][:user]        = 'apache'
  default[:apache][:group]       = 'apache'
  default[:apache][:binary]      = '/usr/sbin/httpd'
  default[:apache][:icondir]     = '/var/www/icons/'
  default[:apache][:init_script] = '/etc/init.d/httpd'
  if node['platform_version'].to_f >= 6 then
    default[:apache][:pid_file] = '/var/run/httpd/httpd.pid'
  else
    default[:apache][:pid_file] = '/var/run/httpd.pid'
  end
  default[:apache][:lib_dir]    = node[:kernel][:machine] =~ /^i[36']86$/ ? '/usr/lib/httpd' : '/usr/lib64/httpd'
  default[:apache][:libexecdir] = "#{node[:apache][:lib_dir]}/modules"
  default[:apache][:document_root] = '/var/www/html'
when 'debian','ubuntu'
  default[:apache][:dir]         = '/etc/apache2'
  default[:apache][:log_dir]     = '/var/log/apache2'
  default[:apache][:user]        = 'www-data'
  default[:apache][:group]       = 'www-data'
  default[:apache][:binary]      = '/usr/sbin/apache2'
  default[:apache][:icondir]     = '/usr/share/apache2/icons'
  default[:apache][:init_script] = '/etc/init.d/apache2'
  default[:apache][:pid_file]    = '/var/run/apache2.pid'
  default[:apache][:lib_dir]     = '/usr/lib/apache2'
  default[:apache][:libexecdir]  = "#{node[:apache][:lib_dir]}/modules"
  default[:apache][:document_root] = '/var/www'
else
  raise 'Bailing out, unknown platform.'
end

# General settings
default[:apache][:listen_ports] = [ '80','443' ]
default[:apache][:contact] = 'ops@example.com'
default[:apache][:timeout] = 120
default[:apache][:keepalive] = 'Off'
default[:apache][:keepaliverequests] = 100
default[:apache][:keepalivetimeout] = 3
default[:apache][:deflate_types] = ['application/javascript',
                                    'application/json',
                                    'application/x-javascript',
                                    'application/xhtml+xml',
                                    'application/xml',
                                    'text/css',
                                    'text/html',
                                    'text/javascript',
                                    'text/plain',
                                    'text/xml']

# Security
default[:apache][:servertokens] = 'Prod'
default[:apache][:serversignature] = 'Off'
default[:apache][:traceenable] = 'Off'
default[:apache][:hide_info_headers] = true

# Prefork Attributes
default[:apache][:prefork][:startservers] = 16
default[:apache][:prefork][:minspareservers] = 16
default[:apache][:prefork][:maxspareservers] = 32
default[:apache][:prefork][:serverlimit] = 400
default[:apache][:prefork][:maxclients] = 400
default[:apache][:prefork][:maxrequestsperchild] = 10000

# Worker Attributes
default[:apache][:worker][:startservers] = 4
default[:apache][:worker][:maxclients] = 1024
default[:apache][:worker][:minsparethreads] = 64
default[:apache][:worker][:maxsparethreads] = 192
default[:apache][:worker][:threadsperchild] = 64
default[:apache][:worker][:maxrequestsperchild] = 10000

# logrotate
default[:apache][:logrotate][:schedule] = 'daily'
default[:apache][:logrotate][:rotate] = '30'
default[:apache][:logrotate][:delaycompress] = true
default[:apache][:logrotate][:mode] = '640'
default[:apache][:logrotate][:owner] = 'root'
default[:apache][:logrotate][:group] = 'adm'

include_attribute 'apache2::customize'
