template "#{node[:scalarium_agent_root]}/TARGET_VERSION" do
  cookbook 'agent_version'
  source 'TARGET_VERSION.erb'
  backup false
  owner 'scalarium-agent'
  group 'scalarium-agent'
  mode 0600
  variables :version => node.scalarium.agent_version
end
