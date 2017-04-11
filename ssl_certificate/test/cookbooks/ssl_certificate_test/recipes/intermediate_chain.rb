# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Recipe:: intermediate_chain
# Author:: Steve Meinel (<steve.meinel@caltech.edu>)
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
ssl_certificate 'chain-data-bag' do
  namespace cert_name
end

cert2_name = 'chain-data-bag2'
source = 'attribute'
node.default[cert2_name]['ssl_key']['source'] = source
node.default[cert2_name]['ssl_key']['content'] = <<EOC
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
node.default[cert2_name]['ssl_cert']['source'] = source
node.default[cert2_name]['ssl_cert']['content'] = <<EOC
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
node.default[cert2_name]['ssl_chain']['name'] = 'dummy-ca-bundle2.pem'
node.default[cert2_name]['ssl_chain']['source'] = source
node.default[cert2_name]['ssl_chain']['content'] = <<EOC
-----BEGIN CERTIFICATE-----
MIIEwzCCA6ugAwIBAgIQf3HB06ImsNKxE/PmgWdkPjANBgkqhkiG9w0BAQUFADBv
MQswCQYDVQQGEwJTRTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFk
ZFRydXN0IEV4dGVybmFsIFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBF
eHRlcm5hbCBDQSBSb290MB4XDTEwMTIwNzAwMDAwMFoXDTIwMDUzMDEwNDgzOFow
UTELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUludGVybmV0MjERMA8GA1UECxMISW5D
b21tb24xGzAZBgNVBAMTEkluQ29tbW9uIFNlcnZlciBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAJd8x8j+s+kgaqOkT46ONFYGs3psqhCbSGErNpBp
4zQKR6e7e96qavvrgpWPyh1/r3WmqEzaIGdhGg2GwcrBh6+sTuTeYhsvnbGYr8YB
+xdw26wUWexvPzN/ppgL5OI4r/V/hW0OdASd9ieGx5uP53EqCPQDAkBjJH1AV49U
4FR+thNIYfHezg69tvpNmLLZDY15puCqzQyRmqXfq3O7yhR4XEcpocrFup/H2mD3
/+d/8tnaoS0PSRan0wCSz4pH2U341ZVm03T5gGMAT0yEFh+z9SQfoU7e6JXWsgsJ
iyxrx1wvjGPJmctSsWJ7cwFif2Ns2Gig7mqojR8p89AYrK0CAwEAAaOCAXcwggFz
MB8GA1UdIwQYMBaAFK29mHo0tCb3+sQmVO8DveAky1QaMB0GA1UdDgQWBBRIT1r6
L0qaXuBQ82t7VaXe9b40XTAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB
/wIBADARBgNVHSAECjAIMAYGBFUdIAAwRAYDVR0fBD0wOzA5oDegNYYzaHR0cDov
L2NybC51c2VydHJ1c3QuY29tL0FkZFRydXN0RXh0ZXJuYWxDQVJvb3QuY3JsMIGz
BggrBgEFBQcBAQSBpjCBozA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1
c3QuY29tL0FkZFRydXN0RXh0ZXJuYWxDQVJvb3QucDdjMDkGCCsGAQUFBzAChi1o
dHRwOi8vY3J0LnVzZXJ0cnVzdC5jb20vQWRkVHJ1c3RVVE5TR0NDQS5jcnQwJQYI
KwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcNAQEF
BQADggEBAJNmIYB0RYVLwqvOMrAp/t3f1iRbvwNqb1A+DhuzDYijW+7EpBI7Vu8G
f89/IZVWO0Ex/uGqk9KV85UNPEerylwmrT7x+Yw0bhG+9GfjAkn5pnx7ZCXdF0by
UOPjCiE6SSTNxoRlaGdosEUtR5nNnKuGKRFy3NacNkN089SXnlag/l9AWNLV1358
xY4asgRckmYOha0uBs7Io9jrFCeR3s8XMIFTtmYSrTfk9e+WXCAONumsYn0ZgYr1
kGGmSavOPN/mymTugmU5RZUWukEGAJi6DFZh5MbGhgHPZqkiKQLWPc/EKo2Z3vsJ
FJ4O0dXG14HdrSSrrAcF4h1ow3BmX9M=
-----END CERTIFICATE-----
EOC
cert = ssl_certificate 'chain-data-bag2' do
  namespace cert2_name
end

include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'
web_app node['fqdn'] do
  cookbook 'ssl_certificate'
  docroot node['apache']['docroot_dir']
  server_name cert.common_name
  ssl_key cert.key_path
  ssl_cert cert.cert_path
  ssl_chain cert.chain_path
  ssl_compatibility :old
  extra_directives EnableSendfile: 'On'
end
