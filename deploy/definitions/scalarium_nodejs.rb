define :scalarium_nodejs do
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

  template "#{deploy[:deploy_to]}/shared/config/scalarium.js" do
    cookbook 'scalarium_nodejs'
    source 'scalarium.js.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:database => deploy[:database], :memcached => deploy[:memcached], :roles => node[:scalarium][:roles])
  end

  template "/etc/monit/conf.d/node_web_app-#{application}.monitrc" do
    source 'node_web_app.monitrc.erb'
    cookbook 'scalarium_nodejs'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      :deploy => deploy,
      :application_name => application,
      :monitored_script => "#{deploy[:deploy_to]}/current/server.js"
    )
    notifies :restart, resources(:service => 'monit'), :immediately
  end
end
