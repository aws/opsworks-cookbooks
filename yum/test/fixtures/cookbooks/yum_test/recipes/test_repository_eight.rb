# The simplest case

yum_repository 'test8' do
  source 'custom_template.erb'
  description 'an test'
  baseurl 'http://drop.the.baseurl.biz'
  action :create
end
