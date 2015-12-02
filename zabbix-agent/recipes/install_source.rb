# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: agent_source
#
# Copyright 2011, Efactures
#
# Apache 2.0
#
case node['platform']
when 'ubuntu', 'debian'
  include_recipe 'apt'
  # install some dependencies
  %w(libcurl3 libcurl4-openssl-dev).each do |pck|
    package pck do
      action :install
    end
  end

when 'redhat', 'centos', 'scientific', 'amazon', 'fedora'
  %w(curl-devel openssl-devel redhat-lsb).each do |pck|
    package pck do
      action :install
    end
  end
end

include_recipe 'build-essential'
# --prefix is controlled by install_dir
configure_options = node['zabbix']['agent']['configure_options'].dup
configure_options = (configure_options || []).delete_if do |option|
  option.match(/\s*--prefix(\s|=).+/)
end
node.normal['zabbix']['agent']['configure_options'] = configure_options

remote_file "#{Chef::Config[:file_cache_path]}/#{node['zabbix']['agent']['tar_file']}" do
  source node['zabbix']['agent']['source_url']
  mode '0644'
  action :create
  notifies :run, 'bash[install_program]', :immediately
end

source_dir = "#{node['zabbix']['install_dir']}/zabbix-#{node['zabbix']['agent']['version']}"
bash 'install_program' do
  user 'root'
  cwd node['zabbix']['install_dir']
  code <<-EOH
    tar -zxf #{Chef::Config[:file_cache_path]}/#{node['zabbix']['agent']['tar_file']}
    (cd #{source_dir} && ./configure --enable-agent --prefix=#{node['zabbix']['install_dir']} #{node['zabbix']['agent']['configure_options'].join(' ')})
    (cd #{source_dir} && make install && touch already_built)
  EOH
  action :nothing
end
