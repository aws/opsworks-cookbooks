template "#{node[:opsworks_agent][:shared_dir]}/TARGET_VERSION" do
  Chef::Log.info "Updating agent TARGET_VERSION to #{node.opsworks.agent_version}"
  source 'TARGET_VERSION.erb'
  backup false
  owner node[:opsworks_agent][:user]
  group node[:opsworks_agent][:group]
  mode 0600
  variables :version => node.opsworks.agent_version
end
