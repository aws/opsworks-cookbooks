#
# Cookbook Name:: newrelic
# Provider:: agent_php
#
# Copyright 2012-2015, Escape Studios
#

# include helper methods
include NewRelic::Helpers

use_inline_resources if defined?(use_inline_resources)

action :install do
  # Check license key provided
  check_license

  # check config_file attribute value
  fail "Please specify the path to your New Relic php agent config file (#{new_resource.config_file})" if new_resource.config_file.nil?

  newrelic_repository
  newrelic_php5_broken
  newrelic_php_agent
  webserver_service if new_resource.service_name
  newrelic_install
  newrelic_daemon
  newrelic_php5enmod
  generate_agent_config
  delete_config_file
  startup_mode_config
  stub_service

  # https://newrelic.com/docs/php/newrelic-daemon-startup-modes
  Chef::Log.info "newrelic-daemon startup mode: #{new_resource.startup_mode}"
end

action :remove do
  newrelic_remove
end

def newrelic_php5_broken
  # the older version (3.0) had a bug in the init scripts that when it shut down the daemon
  # it would also kill dpkg as it was trying to upgrade let's remove the old package before continuing
  package 'newrelic-php5-broken' do
    # set package_name attribute explicitly as the name attribute is *not* the correct package name
    # so not to clash with the package resource block below... (see issue #109 for more information)
    package_name 'newrelic-php5'
    action :remove
    version '3.0.5.95'
  end
end

def newrelic_php_agent
  # install/update latest php agent
  package 'newrelic-php5' do
    action new_resource.action
    notifies :run, 'execute[newrelic-install]', :immediately
  end
end

def newrelic_install
  # run newrelic-install
  install_silently = new_resource.install_silently ? 'true' : 'false'
  execute 'newrelic-install' do
    command 'newrelic-install install'
    if install_silently
      environment(
        'NR_INSTALL_SILENT' => '1'
      )
    end
    action :nothing
    notifies :reload, "service[#{new_resource.service_name}]", :delayed if new_resource.service_name
  end
end

def newrelic_daemon
  service 'newrelic-daemon' do
    supports :status => true, :start => true, :stop => true, :restart => true
  end
end

def webserver_service
  service new_resource.service_name do
    supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
  end
end

def newrelic_php5enmod
  execute_php5enmod = new_resource.execute_php5enmod ? 'true' : 'false'
  # run php5enmod newrelic
  execute 'newrelic-php5enmod' do
    command 'php5enmod newrelic'
    action :nothing
    only_if execute_php5enmod
  end
end

def generate_agent_config
  # configure New Relic INI file and set the daemon related options (documented at /usr/lib/newrelic-php5/scripts/newrelic.ini.template)
  # and reload the web server in order to pick up the new settings
  execute_php5enmod = new_resource.execute_php5enmod ? 'true' : 'false'
  template new_resource.config_file do
    cookbook new_resource.cookbook_ini
    source new_resource.source_ini
    owner 'root'
    group 'root'
    mode 0644
    variables(
      :resource => new_resource
    )
    action :create
    if execute_php5enmod
      notifies :run, 'execute[newrelic-php5enmod]', :immediately
    end
    notifies :reload, "service[#{new_resource.service_name}]", :delayed if new_resource.service_name
  end
end

def delete_config_file
  if new_resource.config_file_to_be_deleted
    # delete the New Relic PHP agent-generated config file
    # see issues #119 and #143
    file new_resource.config_file_to_be_deleted do
      action :delete
    end
  else
    Chef::Log.warn 'You\'ve opted not to delete any PHP agent-generated config file.'
  end
end

def startup_mode_config
  case new_resource.startup_mode
  when 'agent'
    # agent startup mode
    # ensure that the daemon isn't currently running
    service 'newrelic-daemon' do
      action [:disable, :stop] # stops the service if it's running and disables it from starting at system boot time
    end
    # ensure that the file /etc/newrelic/newrelic.cfg does not exist if it does, move it aside (or remove it)
    execute 'newrelic-backup-cfg' do
      command 'mv /etc/newrelic/newrelic.cfg /etc/newrelic/newrelic.cfg.external'
      only_if { ::File.exist?('/etc/newrelic/newrelic.cfg') }
    end
    # ensure that the file /etc/newrelic/upgrade_please.key does not exist if it does, move it aside (or remove it)
    execute 'newrelic-backup-key' do
      command 'mv /etc/newrelic/upgrade_please.key /etc/newrelic/upgrade_please.key.external'
      only_if { ::File.exist?('/etc/newrelic/upgrade_please.key') }
    end
  when 'external'
    # external startup mode
    # configure proxy daemon settings
    template '/etc/newrelic/newrelic.cfg' do
      cookbook new_resource.cookbook
      source new_resource.source
      owner 'root'
      group 'root'
      mode 0644
      variables(
        :resource => new_resource
      )
      action :create
      notifies :restart, 'service[newrelic-daemon]', :immediately
      notifies :reload, "service[#{new_resource.service_name}]", :delayed if new_resource.service_name
    end
    service 'newrelic-daemon' do
      action [:enable, :start] # starts the service if it's not running and enables it to start at system boot time
    end
  else
    fail "#{new_resource.startup_mode} is not a valid newrelic-daemon startup mode."
  end
end

def newrelic_remove
  package 'newrelic-php5' do
    package_name 'newrelic-php5'
    action :remove
  end
end

def stub_service
  # only used for ChefSpec-purposes
  # we don't want to redeclare node['newrelic']['php_agent']['web_server']['service_name'] (eg. apache2)
  # so decided to add a 'stub_service' to the resource collection which can then be used in the unit test(s)
  service 'stub_service' do
    action :nothing
  end
end
