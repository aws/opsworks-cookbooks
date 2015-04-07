include_recipe 'build-essential'

# Ensure our directories exist
directory node[:geminabox][:config_directory] do
  action :create
  recursive true
  mode '0755'
end

directory File.join(node[:geminabox][:base_directory], node[:geminabox][:data_directory]) do
  action :create
  recursive true
  mode '0755'
  owner node[:geminabox][:www_user]
  group node[:geminabox][:www_group]
end

# Install the gem
gem_package('geminabox') do
  action :install
  version node[:geminabox][:version] if node[:geminabox][:version]
end

# Setup the frontend
case node[:geminabox][:frontend].to_sym
when :nginx
  include_recipe 'geminabox::nginx'
else
  raise ArgumentError.new "Unknown frontend style provided: #{node[:geminabox][:frontend]}"
end

# Setup the backend
case node[:geminabox][:backend].to_sym
when :unicorn
  include_recipe 'geminabox::unicorn'
else
  raise ArgumentError.new "Unknown backend style provided: #{node[:geminabox][:backend]}"
end

# Setup the init
case node[:geminabox][:init].to_sym
when :bluepill
  include_recipe 'geminabox::bluepill'
when :runit
  include_recipe 'geminabox::runit'
else
  raise ArgumentError.new "Unknown init style provided: #{node[:geminabox][:init]}"
end

# Configure geminabox
template File.join(node[:geminabox][:base_directory], 'config.ru') do
  source 'config.ru.erb'
  variables(
    :geminabox_data_directory => File.join(node[:geminabox][:base_directory], node[:geminabox][:data_directory]),
    :geminabox_build_legacy => node[:geminabox][:build_legacy],
    :geminabox_rubygems_proxy => node[:geminabox][:rubygems_proxy]
  )
  mode '0644'
  notifies :restart, 'service[geminabox]'
end
