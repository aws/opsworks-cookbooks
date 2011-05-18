define :scalarium_nodejs do
  deploy = params[:deploy_data]
  application = params[:app]

  service 'monit' do
    action :nothing
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
    notifies :restart, resources(:service => 'monit')
  end
end
