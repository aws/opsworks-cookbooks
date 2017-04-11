# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Attributes:: default
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
# License:: Apache License, Version 2.0
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

default['ssl_certificate']['user'] = 'root'
default['ssl_certificate']['items'] = []

case node['platform']
when 'openbsd', 'freebsd', 'mac_os_x'
  default['ssl_certificate']['group'] = 'wheel'
else
  default['ssl_certificate']['group'] = 'root'
end

case node['platform']
when 'debian', 'ubuntu'
  default['ssl_certificate']['key_dir'] = '/etc/ssl/private'
  default['ssl_certificate']['cert_dir'] = '/etc/ssl/certs'
when 'redhat', 'centos', 'fedora', 'scientific', 'amazon'
  default['ssl_certificate']['key_dir'] = '/etc/pki/tls/private'
  default['ssl_certificate']['cert_dir'] = '/etc/pki/tls/certs'
when 'openbsd', 'freebsd', 'mac_os_x'
  default['ssl_certificate']['key_dir'] = '/etc/ssl'
  default['ssl_certificate']['cert_dir'] = '/etc/ssl'
else
  default['ssl_certificate']['key_dir'] = '/etc'
  default['ssl_certificate']['cert_dir'] = '/etc'
end
