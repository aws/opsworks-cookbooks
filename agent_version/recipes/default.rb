template "#{node[:scalarium][:agent][:shared_dir]}/TARGET_VERSION" do
  source 'TARGET_VERSION.erb'
  backup false
  owner node[:scalarium][:agent][:user]
  group node[:scalarium][:agent][:group]
  mode 0600
  variables :version => node.scalarium.agent_version
end
