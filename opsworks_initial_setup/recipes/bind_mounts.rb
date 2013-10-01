node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
  directory source do
    recursive true
    action :create
    mode "0755"
  end
end

include_recipe 'opsworks_initial_setup::autofs'
