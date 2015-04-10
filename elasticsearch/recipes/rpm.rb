# See <http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/_linux.html>

filename = node.elasticsearch[:rpm_url].split('/').last

yum_repository 'logstash' do
  description "logstash repository for #{node['elasticsearch']['major_version']}.x packages"
  baseurl "http://packages.elasticsearch.org/elasticsearch/#{node['elasticsearch']['major_version']}/centos"
  gpgkey 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
  only_if { node['platform'] == 'centos' }
end

package 'elasticsearch' do
  action :install
end