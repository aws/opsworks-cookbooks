# See <http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/_linux.html>

filename = node.elasticsearch[:rpm_url].split('/').last

remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
  source   node.elasticsearch[:rpm_url]
  checksum node.elasticsearch[:rpm_sha]
  mode 00644
end

rpm_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
  action :install
end
