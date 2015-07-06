#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2013, David Radcliffe
#

if node['solr']['install_java']
  include_recipe 'apt'
  include_recipe 'java'
end

src_filename = ::File.basename(node['solr']['url'])
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"
extract_path = "#{node['solr']['dir']}-#{node['solr']['version']}"

remote_file src_filepath do
  source node['solr']['url']
  action :create_if_missing
end

bash 'unpack_solr' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    mkdir -p #{extract_path}
    tar xzf #{src_filename} -C #{extract_path} --strip 1
    chown -R #{node['solr']['user']}:#{node['solr']['group']} #{extract_path}
  EOH
  not_if { ::File.exist?(extract_path) }
end

directory node['solr']['data_dir'] do
  owner node['solr']['user']
  group node['solr']['group']
  recursive true
  action :create
end

template '/var/lib/solr.start' do
  source 'solr.start.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    :solr_dir => extract_path,
    :solr_home => node['solr']['data_dir'],
    :port => node['solr']['port'],
    :pid_file => node['solr']['pid_file'],
    :log_file => node['solr']['log_file'],
    :java_options => node['solr']['java_options']
  )
  only_if { !platform_family?('debian') }
end

template '/etc/init.d/solr' do
  source platform_family?('debian') ? 'initd.debian.erb' : 'initd.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(
    :solr_dir => extract_path,
    :solr_home => node['solr']['data_dir'],
    :port => node['solr']['port'],
    :pid_file => node['solr']['pid_file'],
    :log_file => node['solr']['log_file'],
    :user => node['solr']['user'],
    :java_options => node['solr']['java_options']
  )
end

service 'solr' do
  supports :restart => true, :status => true
  action [:enable, :start]
end
