# See <http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/_linux.html>

apt_repository 'elasticsearch' do
  uri "http://packages.elasticsearch.org/elasticsearch/#{node['elasticsearch']['major_version']}/debian"
  distribution 'stable'
  components ['main']
  key 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
  only_if { node['platform'] == 'debian' || node['platform'] == 'ubuntu' }
end

package 'elasticsearch' do
  action :install
end


ruby_block "Set heap size in /etc/default/elasticsearch" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/default/elasticsearch")
    fe.insert_line_if_no_match(/ES_HEAP_SIZE=/, "ES_HEAP_SIZE=#{node.elasticsearch[:allocated_memory]}")
    fe.search_file_replace_line(/ES_HEAP_SIZE=/, "ES_HEAP_SIZE=#{node.elasticsearch[:allocated_memory]}") # if the value has changed but the line exists in the file
    fe.write_file
  end
end