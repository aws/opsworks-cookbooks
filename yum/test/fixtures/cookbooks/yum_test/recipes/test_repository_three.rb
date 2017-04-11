# create alias 'add'
yum_repository 'test3' do
  description 'an test'
  baseurl 'http://drop.the.baseurl.biz'
  action :add
end
