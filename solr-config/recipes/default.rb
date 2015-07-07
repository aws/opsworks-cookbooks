
node[:deploy].each do |app_name, deploy|
  Chef::Log.info(deploy)

  env = deploy["rails_env"].to_sym

  execute "if [ -f #{node[:config][env][:path]}/solr ]; then mv #{node[:config][env][:path]}/solr #{node[:config][env][:path]}/solr-#{Time.now.to_s}; fi"

  remote_directory "#{node[:config][env][:path]}/solr-webapp/webapp/WEB-INF/lib/ext-lib" do
    files_mode '0640'
    mode '0770'
    owner 'deploy'
    source "config"
  end

  remote_directory "#{node[:config][env][:root]}/solr" do
    files_mode '0640'
    mode '0770'
    owner 'deploy'
    source "ext-lib"
  end

  service 'solr' do
    supports :restart => true, :status => true
    action [:enable, :start]
  end
end
