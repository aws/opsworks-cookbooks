
node[:deploy].each do |app_name, deploy|
  Chef::Log.info(deploy)

  env = deploy["rails_env"].to_sym

  remote_directory "#{node[:default][env][:root]}/lib/ext-lib" do
    files_mode '0640'
    mode '0770'
    owner 'deploy'
    source "ext-lib"
  end

  template "#{node[:default][env][:root]}/../bin/solr.in.sh" do
    owner 'deploy'
    variables( solr_java_mem: node[:default][env][:solr_java_mem] )
    source 'solr.in.sh.erb'
  end

  service 'solr' do
    supports :restart => true, :status => true
    action [:enable, :start]
  end
end
