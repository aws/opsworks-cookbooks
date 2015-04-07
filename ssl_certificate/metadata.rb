# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Author:: Raul Rodriguez (<raul@onddo.com>)
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014-2015 Onddo Labs, SL. (www.onddo.com)
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

name 'ssl_certificate'
maintainer 'Onddo Labs, Sl.'
maintainer_email 'team@onddo.com'
license 'Apache 2.0'
description <<-EOS
The main purpose of this cookbook is to make it easy for other cookbooks to
support SSL. With the resource included, you will be able to manage certificates
reading them from attributes, data bags or chef-vaults. Exposing its
configuration through node attributes.
EOS
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.5.0' # WiP

supports 'amazon'
supports 'debian'
supports 'centos'
supports 'fedora'
supports 'freebsd'
supports 'redhat'
supports 'ubuntu'

provides 'ssl_certificate'

attribute 'ssl_certificate/key_dir',
          display_name: 'ssl_certificate key dir',
          description: 'Default SSL key directory.',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'ssl_certificate/cert_dir',
          display_name: 'ssl_certificate cert dir',
          description: 'Default SSL certificate directory.',
          type: 'string',
          required: 'optional',
          calculated: true

grouping 'ssl_certificate/service',
         title: 'ssl_certificate service',
         description: 'ssl_certificate service defaults.'

attribute 'ssl_certificate/service/cipher_suite',
          display_name: 'ssl_certificate service cipher suite',
          description: 'Service default SSL cipher suite.',
          type: 'string',
          required: 'optional',
          default: nil

grouping 'ssl_certificate/service/protocols',
         title: 'ssl_certificate service protocol',
         description: 'ssl_certificate service SSL protocols.'

attribute 'ssl_certificate/service/protocols/nginx',
          display_name: 'ssl_certificate service protocol',
          description: 'nginx service default SSL protocols.',
          type: 'string',
          required: 'optional',
          default: nil

attribute 'ssl_certificate/service/protocols/apache',
          display_name: 'ssl_certificate web protocol',
          description: 'Apache web service default SSL protocols.',
          type: 'string',
          required: 'optional',
          default: nil

attribute 'ssl_certificate/service/compatibility',
          display_name: 'ssl_certificate service compatibility',
          description: 'Service SSL compatibility level.',
          type: 'string',
          required: 'optional',
          default: nil

attribute 'ssl_certificate/service/use_hsts',
          display_name: 'ssl_certificate web use hsts',
          description: 'Whether to enable HSTS in the service.',
          type: 'string',
          required: 'optional',
          default: 'true'

attribute 'ssl_certificate/service/use_stapling',
          display_name: 'ssl_certificate web use stapling',
          description: 'Whether to enable OCSP stapling in the service.',
          type: 'string',
          required: 'optional',
          calculated: true
