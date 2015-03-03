# delete alias 'remove'
yum_repository 'test5' do
  description 'an test'
  baseurl 'http://drop.the.baseurl.biz'
  action :remove
end
