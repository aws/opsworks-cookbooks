
node[:deploy].each do |app_name, deploy|
  Chef::Log.info(deploy)

  env = deploy["rails_env"].to_sym

  execute "if [ -f #{node[:config][env][:root]}/solr ]; then mv #{node[:config][env][:path]}/solr #{node[:config][env][:root]}/solr-#{Time.now.to_s}; fi"

  remote_directory "#{node[:config][env][:root]}/solr-webapp/webapp/WEB-INF/lib/ext-lib" do
    files_mode '0640'
    mode '0770'
    owner 'deploy'
    source "config"
  end

  template "#{node[:config][env][:root]}/../bin/solr.in.sh" do
    owner 'deploy'
    variables => { solr_java_mem: node[:config][env][:solr_java_mem] }

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
