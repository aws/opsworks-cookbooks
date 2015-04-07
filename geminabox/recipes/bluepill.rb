include_recipe "bluepill"

gem_package('red_unicorn') do
  action :install
end

template '/etc/init/geminabox.conf' do
  source 'upstart-geminabox-bluepill.erb'
  variables(
    :www_user => node[:geminabox][:www_user],
    :base_directory => node[:geminabox][:base_directory]
  )
  notifies :restart, 'service[geminabox]'
end

template '/etc/bluepill/geminabox.pill' do
  source 'bluepill-geminabox.pill.erb'
  variables(
    :pid => File.join(node[:geminabox][:base_directory], 'unicorn.pid'),
    :working_directory => node[:geminabox][:base_directory],
    :exec => node[:geminabox][:unicorn][:exec],
    :config => File.join(node[:geminabox][:config_directory], 'geminabox.unicorn.app'),
    :process_user => node[:geminabox][:unicorn][:process_user],
    :process_group => node[:geminabox][:unicorn][:process_group],
    :maxmemory => node[:geminabox][:unicorn][:maxmemory],
    :maxcpu => node[:geminabox][:unicorn][:maxcpu],
    :bin_dir => node[:languages][:ruby][:bin_dir]
  )
  notifies :restart, 'service[geminabox]'
end

service 'geminabox' do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
