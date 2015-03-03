# gpgkey alias 'keyurl'
yum_repository 'test7' do
  description 'an test'
  url 'http://drop.the.baseurl.biz'
  keyurl 'http://example.com/RPM-GPG-KEY-FOOBAR-1'
  action :create
end
