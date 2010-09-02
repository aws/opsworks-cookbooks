#
# Cookbook Name:: deploy
# Recipe:: rails-undeploy
#

include_recipe "deploy"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping deploy::rails-undeploy application #{application} as it is not an Rails app")
    next
  end
  
  include_recipe "#{deploy[:stack][:service]}::service" if deploy[:stack][:service]

  link "/etc/apache2/sites-enabled/#{application}.conf" do
    action :delete
    only_if do 
      File.exists?("/etc/apache2/sites-enabled/#{application}.conf")
    end
    
    if deploy[:stack][:needs_reload]
      notifies :restart, resources(:service => deploy[:stack][:service])
    end
  end

  file "/etc/apache2/sites-available/#{application}.conf" do
    action :delete
    only_if do 
      File.exists?("/etc/apache2/sites-available/#{application}.conf")
    end
  end
  
  directory "#{deploy[:deploy_to]}" do
    recursive true
    action :delete

    if deploy[:stack][:needs_reload]
      notifies :restart, resources(:service => deploy[:stack][:service])
    end

    only_if do 
      File.exists?("#{deploy[:deploy_to]}")
    end
  end
  
end


