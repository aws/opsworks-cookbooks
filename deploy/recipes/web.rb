include_recipe "deploy::user"
include_recipe "nginx::service"
include_recipe 'deploy::source'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'static'
    Chef::Log.debug("Skipping deploy::web application #{application} as it is not an static HTML app")
    next
  end
  
  template "#{node[:nginx][:dir]}/sites-available/#{application}" do
    source "site.erb"
    cookbook "nginx"
    owner "root"
    group "root"
    mode 0644
    variables :application => deploy
    
    notifies :reload, resources(:service => "nginx")
  end
  
  directory "#{node[:nginx][:dir]}/ssl" do
    action :create
    owner "root"
    group "root"
    mode 0600
  end
  
  template "#{node[:nginx][:dir]}/ssl/#{deploy[:domains].first}.crt" do
    cookbook 'nginx'
    mode '0600'
    source "ssl.key.erb"
    variables :key => deploy[:ssl_certificate]
    only_if do
      deploy[:ssl_support]
    end
  end
  
  template "#{node[:nginx][:dir]}/ssl/#{deploy[:domains].first}.key" do
    cookbook 'nginx'
    mode '0600'
    source "ssl.key.erb"
    variables :key => deploy[:ssl_certificate_key]
    only_if do
      deploy[:ssl_support]
    end
  end
  
  template "#{node[:nginx][:dir]}/ssl/#{deploy[:domains].first}.ca" do
    cookbook 'nginx'
    mode '0600'
    source "ssl.key.erb"
    variables :key => deploy[:ssl_certificate_ca]
    only_if do
      deploy[:ssl_support] && deploy[:ssl_certificate_ca]
    end
  end
  
  # delete default virtual host
  file "#{node[:nginx][:dir]}/sites-enabled/default" do
    action :delete
  end
  
  nginx_site application
end