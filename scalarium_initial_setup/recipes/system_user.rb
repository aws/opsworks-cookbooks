user 'the agent user' do
  username node[:scalarium][:agent][:user]
  comment 'AWS OpsWorks agent user'
  system true
  shell "/bin/false"
end

