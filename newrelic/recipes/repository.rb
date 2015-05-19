#
# Cookbook Name:: newrelic
# Recipe:: repository
#
# Copyright 2012-2015, Escape Studios
#

case node['platform_family']
when 'debian'
  apt_repository 'newrelic' do
    uri node['newrelic']['repository']['uri']
    distribution node['newrelic']['repository']['distribution']
    components node['newrelic']['repository']['components']
    key node['newrelic']['repository']['key']
  end
when 'rhel'
  yum_repository 'newrelic' do
    description 'New Relic packages for Enterprise Linux 5 - $basearch'
    baseurl node['newrelic']['repository']['uri']
    gpgkey node['newrelic']['repository']['key']
  end
end
