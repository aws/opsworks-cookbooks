# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate_test
# Recipe:: nginx
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

cert_name = 'chain-data-bag'

source = 'data-bag'
node.default[cert_name]['ssl_key']['source'] = source
node.default[cert_name]['ssl_key']['bag'] = 'ssl'
node.default[cert_name]['ssl_key']['item'] = 'key'
node.default[cert_name]['ssl_key']['item_key'] = 'content'
node.default[cert_name]['ssl_key']['encrypted'] = true
node.default[cert_name]['ssl_cert']['source'] = source
node.default[cert_name]['ssl_cert']['bag'] = 'ssl'
node.default[cert_name]['ssl_cert']['item'] = 'cert'
node.default[cert_name]['ssl_cert']['item_key'] = 'content'
node.default[cert_name]['ssl_chain']['name'] = 'dummy-ca-bundle.pem'
node.default[cert_name]['ssl_chain']['source'] = source
node.default[cert_name]['ssl_chain']['bag'] = 'ssl'
node.default[cert_name]['ssl_chain']['item'] = 'chain'
node.default[cert_name]['ssl_chain']['item_key'] = 'content'
cert = ssl_certificate 'chain-data-bag' do
  namespace cert_name
end

include_recipe 'nginx'

vhost_file =
  File.join(node['nginx']['dir'], 'sites-available', 'ssl_certificate')
template vhost_file do
  source 'nginx_vhost.erb'
  mode 00644
  owner 'root'
  group 'root'
  variables(
    name: 'ssl_certificate',
    server_name: 'ssl.onddo.com',
    docroot: '/var/www',
    ssl_key: cert.key_path,
    ssl_cert: cert.chain_combined_path,
    ssl_compatibility: :intermediate
  )
  notifies :reload, 'service[nginx]'
end

nginx_site 'ssl_certificate' do
  enable true
end
