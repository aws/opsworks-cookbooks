file '/etc/apt/sources.list.d/beats.list' do
  content 'deb https://packages.elastic.co/beats/apt stable main'
  mode '0755'
  owner 'root'
  group 'root'
end

include_recipe 'apt'

package 'filebeat'


