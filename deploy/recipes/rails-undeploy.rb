#
# Cookbook Name:: deploy
# Recipe:: rails-undeploy

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping deploy::rails-undeploy application #{application} as it is not an Rails app")
    next
  end

  case node[:opsworks][:rails_stack][:name]
  when 'apache_passenger'
    if node[:opsworks][:rails_stack][:service]
      include_recipe "#{node[:opsworks][:rails_stack][:service]}::service"
    end

    link "#{node[:apache][:dir]}/sites-enabled/#{application}.conf" do
      action :delete
      only_if do
        ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application}.conf")
      end
      notifies :restart, "service[#{node[:opsworks][:rails_stack][:service]}]"
    end

    file "#{node[:apache][:dir]}/sites-available/#{application}.conf" do
      action :delete
      only_if do
        ::File.exists?("#{node[:apache][:dir]}/sites-available/#{application}.conf")
      end
      notifies :restart, "service[#{node[:opsworks][:rails_stack][:service]}]"
    end

  when 'nginx_unicorn'
    include_recipe 'nginx::service'

    link "/etc/nginx/sites-enabled/#{application}" do
      action :delete
      only_if do
        ::File.exists?("/etc/nginx/sites-enabled/#{application}")
      end
      notifies :restart, "service[nginx]"
    end

    file "/etc/nginx/sites-available/#{application}" do
      action :delete
      only_if do
        ::File.exists?("/etc/nginx/sites-available/#{application}")
      end
    end

    execute 'stop unicorn and restart nginx' do
      command "sleep #{deploy[:sleep_before_restart]} && \
               #{deploy[:deploy_to]}/shared/scripts/unicorn stop"
      notifies :restart, "service[nginx]"
      action :run
    end

  else
    raise 'Unsupported Rails stack'
  end

  directory "#{deploy[:deploy_to]}" do
    recursive true
    action :delete
    only_if do
      File.exists?("#{deploy[:deploy_to]}")
    end
  end
end
