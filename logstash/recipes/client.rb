file '/etc/apt/sources.list.d/beats.list' do
  content 'deb https://packages.elastic.co/beats/apt stable main'
  mode '0755'
  owner 'root'
  group 'root'
end

apt_update if node['platform_family'] == 'debian' do
  action :update
end

package 'filebeat'


