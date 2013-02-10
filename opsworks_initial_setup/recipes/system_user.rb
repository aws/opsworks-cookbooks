group node[:opsworks_agent][:group]

user 'the agent user' do
  username node[:opsworks_agent][:user]
  gid node[:opsworks_agent][:group]
  comment 'AWS OpsWorks agent user'
  system true
  shell "/bin/false"
end
