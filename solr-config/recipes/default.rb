
node[:deploy].each do |app_name, deploy|
  Chef::Log.info(deploy)

  env = deploy["rails_env"].to_sym

  remote_directory "#{node[:default][env][:root]}/lib/dist" do
    files_mode '0640'
    mode '0770'
    owner 'deploy'
    source "ext-lib"
  end

  Chef::Log.info node[:default][env][:solr_java_mem]

  template "/etc/init.d/solr" do
    owner 'root'
    variables( solr_java_mem: node[:default][env][:solr_java_mem]
               version: node[:default][env][:solr_version]
              )
    mode '0755'
    source 'solr_init.d.sh.erb'
  end

  bash 'cp_dataimporthandler' do
    cwd ::File.dirname(node[:default][env][:root])
    code <<-EOH
      cp #{node[:default][env][:root]}/../dist/solr-dataimporthandler* #{node[:default][env][:root]}/lib/dist/
    EOH
  end


  service 'solr' do
    supports :restart => true, :status => true
    action [:enable, :start]
  end
end
