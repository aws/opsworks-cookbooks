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

  execute "install newrelic php rpm" do
    only_if "rpm -q newrelic-repo-5-3.noarch"
    Chef::Log.debug("newrelic::installing newrelic php rpm")
    command "sudo rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm"
  end

  execute "install newrelic-php5" do
    Chef::Log.debug("newrelic::installing newrelic-php5")
    command "sudo yum -y install newrelic-php5"
  end

  execute "setup newrelic-php5" do
    Chef::Log.debug("newrelic::setting up newrelic-php5")
    command "sudo NR_INSTALL_SILENT=true newrelic-install install"
  end

  service "php-fpm" do
    action :restart
  end

end