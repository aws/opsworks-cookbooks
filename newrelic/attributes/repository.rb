#
# Cookbook Name:: newrelic
# Attributes:: repository
#
# Copyright 2012-2015, Escape Studios
#

default['newrelic']['repository']['key'] = 'http://download.newrelic.com/548C16BF.gpg'

case node['platform_family']
when 'debian'
  default['newrelic']['repository']['uri'] = 'http://download.newrelic.com/debian/'
  default['newrelic']['repository']['distribution'] = 'newrelic'
  default['newrelic']['repository']['components'] = ['non-free']
when 'rhel'
  default['newrelic']['repository']['uri'] = 'http://download.newrelic.com/pub/newrelic/el5/$basearch/'
end
