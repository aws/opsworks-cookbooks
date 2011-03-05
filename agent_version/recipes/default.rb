template '/root/scalarium-agent/TARGET_VERSION' do
  cookbook 'agent_version'
  source 'TARGET_VERSION.erb'
  owner 'root'
  group 'root'
  mode 0600
  variables :version => node.scalarium.agent_version
end
