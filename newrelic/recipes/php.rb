node[:deploy].each do |application, deploy|
  
  template "/etc/php.d/newrelic.ini" do
    cookbook 'newrelic'
    source 'newrelic.ini.erb'
    mode '0660'
    owner 'root'
    group 'root'
    variables(
      :license_key => node[:newrelic][:license],
      :app_name => node[:newrelic][:app_name]
    )
  end

  template "/etc/yum.repos.d/newrelic.repo" do
    cookbook 'newrelic'
    source 'newrelic.repo.erb'
    mode '0660'
    owner 'root'
    group 'root'
  end

  execute "install newrelic-php5" do
    Chef::Log.debug("newrelic::installing newrelic-php5")
    command "sudo yum -y install newrelic-php5"
  end

  execute "setup newrelic-php5" do
    Chef::Log.debug("newrelic::setting up newrelic-php5")
    command "sudo NR_INSTALL_SILENT=true newrelic-install install"
  end

  service "httpd" do
    action :restart
  end

end