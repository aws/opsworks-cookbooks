# The simplest case
yum_repository 'test1' do
  description 'an test'
  baseurl 'http://drop.the.baseurl.biz'
  action :create
end
