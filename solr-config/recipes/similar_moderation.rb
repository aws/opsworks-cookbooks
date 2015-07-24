node[:deploy].each do |app_name, deploy|
  env = deploy[:rails_env]

  remote_directory "#{node[:similar_moderation][env][:path]}/#{node[:praga][env][:core_name]}" do
    files_mode '0640'
    files_owner 'deploy'
    mode '0770'
    owner 'deploy'
    recursive true
    source "cores/#{node[:similar_moderation][env][:core_name]}"
  end

  service 'solr' do
    supports :restart => true, :status => true
    action [:enable, :start]
  end
end
