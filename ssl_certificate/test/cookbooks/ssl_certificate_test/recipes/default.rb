# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate_test
# Recipe:: default
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

include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'

cert1_name = 'dummy1'
node.default[cert1_name]['ssl_cert']['source'] = 'self-signed'
node.default[cert1_name]['ssl_key']['source'] = 'self-signed'
ssl_certificate cert1_name do
  namespace node[cert1_name]
end

ssl_certificate 'dummy2' do
  key_source 'self-signed'
  cert_source 'self-signed'
end

ssl_certificate 'dummy3' do
  source 'self-signed'
  years 5
end

ssl_certificate 'dummy4' do
  source 'self-signed'
  country 'Bilbao'
end

cert5_name = 'dummy5-data-bag'
source = 'data-bag'
node.default[cert5_name]['ssl_key']['source'] = source
node.default[cert5_name]['ssl_key']['bag'] = 'ssl'
node.default[cert5_name]['ssl_key']['item'] = 'key'
node.default[cert5_name]['ssl_key']['item_key'] = 'content'
node.default[cert5_name]['ssl_key']['encrypted'] = true
node.default[cert5_name]['ssl_cert']['source'] = source
node.default[cert5_name]['ssl_cert']['bag'] = 'ssl'
node.default[cert5_name]['ssl_cert']['item'] = 'cert'
node.default[cert5_name]['ssl_cert']['item_key'] = 'content'
ssl_certificate 'dummy5-data-bag' do
  namespace cert5_name
  owner node['apache']['user'] # don't do this in real life, just for testing
  group node['apache']['group'] # don't do this in real life, just for testing
end

cert6_name = 'dummy6-attributes'
source = 'attribute'
node.default[cert6_name]['ssl_key']['source'] = source
node.default[cert6_name]['ssl_key']['content'] = <<EOC
-----BEGIN PRIVATE KEY-----
MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOgkYt9sTZb/mEwG
zNFIOkOrNhtSKyst300Ycdjg/8C1+Ji43SapBZeQpYuymOE0bCa7No0tktvYgxLn
vXxHnW5yJfWbskX9ADAa8LxftyRUiASta9SXoDRF4Usayb1+84TUsDLjP02IjVtc
EiwxnhIp4X8C0jyKopCVP1wc4SwJAgMBAAECgYEAtfw4arCrzvFGwmseS/7UdlIV
U6vB3dLTWMwODBivRrMhVRCvhmxAzwX9UZvMT9hZ5K8lX93XYHPGpZ54pKI73mhT
rkzIWc49J71Yeucli/IdCUj6ZjU6wz7M8S6Iq5PAPet0B43Tgr2GuSpYBTaCGDKs
zPNhUiU/aya0zVnAZxECQQD6Ds7GxFn/way0nrdjOl93daEKg9qKNNcxQc9edO81
4ZQFoB5PGD0FAaSqFfei7kNG4Ab1TkvGKnNLNg1J7ehdAkEA7aiXPGDle9jCmUSm
Qrej2Cs7OJNIm5K3FiqtXyd0/zszHbsp9eT1z5xIbRZhzF85I/xxda3O4brvuJq3
BqmnnQJBAKHgmCfA0OpqvJ0o6ltIXKj+80PVW9KAppZyngXt+TWOVL7Xiwd1D3uA
NtMM6YUGbXMicB65kwA0VvLniO7FHtkCQGJg7KHw1m4q73s0wMJTdH6SfsRPq7nC
xQlnBzehhLv2zJUdGiSQ7/ROFGkb38YTEPtFj84P8djdYkh/uw4GAr0CQA1BCV5C
mCRO24Sn5K9AtA4Cu1NsAM8/sfBvewJ8MjkxCG/lnWjSDNMoVXivo5kk5txT4uVF
1pdo84Vs2Abj3JE=
-----END PRIVATE KEY-----
EOC
node.default[cert6_name]['ssl_cert']['source'] = source
node.default[cert6_name]['ssl_cert']['content'] = <<EOC
-----BEGIN CERTIFICATE-----
MIICjDCCAfWgAwIBAgIJALJSpKd0ZsHVMA0GCSqGSIb3DQEBBQUAMF4xCzAJBgNV
BAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRlcm5ldCBX
aWRnaXRzIFB0eSBMdGQxFzAVBgNVBAMMDm93bmNsb3VkLmxvY2FsMCAXDTE0MDIx
MzE3MzYyMFoYDzIxMTQwMTIwMTczNjIwWjBeMQswCQYDVQQGEwJBVTETMBEGA1UE
CAwKU29tZS1TdGF0ZTEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0cyBQdHkgTHRk
MRcwFQYDVQQDDA5vd25jbG91ZC5sb2NhbDCBnzANBgkqhkiG9w0BAQEFAAOBjQAw
gYkCgYEA6CRi32xNlv+YTAbM0Ug6Q6s2G1IrKy3fTRhx2OD/wLX4mLjdJqkFl5Cl
i7KY4TRsJrs2jS2S29iDEue9fEedbnIl9ZuyRf0AMBrwvF+3JFSIBK1r1JegNEXh
SxrJvX7zhNSwMuM/TYiNW1wSLDGeEinhfwLSPIqikJU/XBzhLAkCAwEAAaNQME4w
HQYDVR0OBBYEFH+LWAqDxMpEObxsdPR/HUxbSvTaMB8GA1UdIwQYMBaAFH+LWAqD
xMpEObxsdPR/HUxbSvTaMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADgYEA
AHeOpZbU6ak47dHfZVevB34JUkuje+nnG01ahDqtRtIuAiXdWE8+r4XeNeQTMQMZ
0/WOwseFPzfG3D9KaynYe7Py7kaACHZweEyVDgRlgxa7U2fJim+/f6pEcRUIfb2F
wCVUQVe2b2XgEGlbTpmzyOHrERKM2C7w0ueeOG/FU04=
-----END CERTIFICATE-----
EOC
cert6 = ssl_certificate cert6_name do
  namespace cert6_name
end

cert7_name = 'dummy7'
source = 'file'
node.default[cert7_name]['ssl_cert']['source'] = source
node.default[cert7_name]['ssl_cert']['path'] = cert6.cert_path
node.default[cert7_name]['ssl_key']['source'] = source
node.default[cert7_name]['ssl_key']['path'] = cert6.key_path
ssl_certificate cert7_name do
  namespace node[cert7_name]
end

# Apache2 test

node.default[node['fqdn']]['organization'] =
  'ssl_certificate apache2 template test'
cert = ssl_certificate node['fqdn'] do
  namespace node['fqdn'].to_s
  notifies :restart, 'service[apache2]'
end

web_app node['fqdn'] do
  # this cookbook includes a virtualhost template for apache2
  cookbook 'ssl_certificate'
  # [...]
  docroot node['apache']['docroot_dir']
  server_name cert.common_name
  ssl_key cert.key_path
  ssl_cert cert.cert_path
  ssl_chain cert.chain_path # nil
  extra_directives EnableSendfile: 'On'
end
