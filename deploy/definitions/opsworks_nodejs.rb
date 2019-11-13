define :opsworks_nodejs do
  deploy = params[:deploy_data]
  application = params[:app]

  service 'monit' do
    action :nothing
  end

  node[:dependencies][:npms].each do |npm, version|
    execute "/usr/local/bin/npm install #{npm}" do
      cwd "#{deploy[:deploy_to]}/current"
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/opsworks.js" do
    cookbook 'opsworks_nodejs'
    source 'opsworks.js.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :database => deploy[:database], 
      :memcached => deploy[:memcached], 
      :layers => node[:opsworks][:layers],
      :services => node[:services],
      :models => node[:models],
      :elasticsearch => node[:elasticsearch]
      )
  end

  template "#{node.default[:monit][:conf_dir]}/node_web_app-#{application}.monitrc" do
    source 'node_web_app.monitrc.erb'
    cookbook 'opsworks_nodejs'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :deploy => deploy,
      :application_name => application,
      :monitored_script => "#{deploy[:deploy_to]}/current/server.js"
    )
    notifies :restart, "service[monit]", :immediately
  end

  file "#{deploy[:deploy_to]}/shared/config/ssl.crt" do
    owner deploy[:user]
    mode 0600
    content deploy[:ssl_certificate]
    only_if do
      deploy[:ssl_support]
    end
  end

  file "#{deploy[:deploy_to]}/shared/config/ssl.key" do
    owner deploy[:user]
    mode 0600
    content deploy[:ssl_certificate_key]
    only_if do
      deploy[:ssl_support]
    end
  end

  file "#{deploy[:deploy_to]}/shared/config/ssl.ca" do
    owner deploy[:user]
    mode 0600
    content deploy[:ssl_certificate_ca]
    only_if do
      deploy[:ssl_support] && deploy[:ssl_certificate_ca].present?
    end
  end
end
