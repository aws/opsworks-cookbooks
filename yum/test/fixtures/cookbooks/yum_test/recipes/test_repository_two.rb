# Full blown parameterization. Exercercises the
# recipe->resource->provider->template chain
yum_repository 'test2' do
  description 'test all the things!'
  baseurl 'http://example.com/wat'
  cost '10'
  enabled true
  enablegroups true
  exclude 'package1 package2 package3'
  failovermethod 'priority'
  fastestmirror_enabled true
  gpgcheck true
  gpgkey 'http://example.com/RPM-GPG-KEY-FOOBAR-1'
  http_caching 'all'
  include_config '/some/other.repo'
  includepkgs 'package4 package5'
  keepalive true
  max_retries '10'
  metadata_expire 'never'
  mirror_expire '300'
  mirrorlist_expire '86400'
  mirrorlist 'http://hellothereiammirrorliststring.biz'
  priority '10'
  proxy 'http://hellothereiamproxystring.biz'
  proxy_username 'kermit'
  proxy_password 'dafrog'
  report_instanceid false
  repositoryid 'unit-test-2'
  skip_if_unavailable true
  sslcacert '/path/to/directory'
  sslclientcert '/path/to/client/cert'
  sslclientkey '/path/to/client/key'
  sslverify true
  timeout '10'
  action :create
end
