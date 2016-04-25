node[:deploy].each do |app_name, deploy|

  Chef::Log.info(deploy)

  env = deploy[:rails_env].present? ?  deploy[:rails_env] : 'production'

  Chef::Log.info(env)

  remote_directory "#{node['recommendation'][env]['path']}/#{node['recommendation'][env]['core_name']}" do
    files_mode '0640'
    files_owner 'deploy'
    mode '0770'
    owner 'deploy'
    recursive true
    source "cores/#{node['recommendation'][env]['core_name']}"
  end

  template "#{node['recommendation'][env]['path']}/#{node['recommendation'][env]['core_name']}/core.properties" do
    source "cores/core.properties.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :name => node['recommendation'][env]['core_name']})
  end

  template "#{node['recommendation'][env]['path']}/#{node['recommendation'][env]['core_name']}/conf/data-config.xml" do
    source "cores/#{node['recommendation'][env]['core_name']}/data-config.xml.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0440
    variables({ :db_url => node['recommendation'][env]['database_url'],
                :db_name => node['recommendation'][env]['database_name'],
                :db_url => node['recommendation'][env]['database_url'],
                :db_user => node['recommendation'][env]['database_user'],
                :db_password => node['recommendation'][env]['database_password']}
             )
  end

  template "/etc/cron.d/solr_recommendation_delta_import" do
    owner 'root'
    variables({ :cron_delta_import => node['recommendation'][env]['cron_delta_import'] })
    mode '0755'
    source 'solr_recommendation_delta_import_cron.sh.erb'
  end

  service 'solr' do
    supports :restart => true, :status => true
    action [:enable, :start]
  end

end
