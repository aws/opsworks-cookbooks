file '/etc/apt/sources.list.d/beats.list' do
  content 'deb https://packages.elastic.co/beats/apt stable main'
  mode '0755'
  owner 'root'
  group 'root'
end

execute 'add_elasticsearch_gpg_key' do
  command 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'
end

execute 'run_apt_key_update' do
  command 'apt-key update'
end

include_recipe 'apt'

package 'filebeat'

template '/etc/filebeat/filebeat.yml' do
  source "filebeat.yml.erb"
  owner "root"
  group "root"
  mode 0644
end
