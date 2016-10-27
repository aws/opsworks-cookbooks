file '/etc/apt/sources.list.d/beats.list' do
  content 'deb https://packages.elastic.co/beats/apt stable main'
  mode '0755'
  owner 'root'
  group 'root'
end

execute 'add_elasticsearch_gpg_key' do
  command 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'
end

include_recipe 'apt'

package 'filebeat'


