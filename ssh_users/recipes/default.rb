group 'opsworks'

existing_ssh_users = load_existing_ssh_users
existing_ssh_users.each do |id, name|
  unless node[:ssh_users][id]
    teardown_user(name)
  end
end

node[:ssh_users].each_key do |id|
  if existing_ssh_users.has_key?(id)
    unless existing_ssh_users[id] == node[:ssh_users][id][:name]
      rename_user(existing_ssh_users[id], node[:ssh_users][id][:name])
    end
  else
    node.set[:ssh_users][id][:uid] = id
    setup_user(node[:ssh_users][id])
  end
  set_public_key(node[:ssh_users][id])
end

template '/etc/sudoers' do
  backup false
  source 'sudoers.erb'
  owner 'root'
  group 'root'
  mode 0440
  variables :sudoers => node[:sudoers]
end
