group 'opsworks'

existing_ssh_users = load_existing_ssh_users
existing_ssh_users.each do |id, name|
  unless node[:ssh_users][id]
    teardown_user(name)
  end
end

node[:ssh_users].each do |id, ssh_user|
  if (existing_name = existing_ssh_users[id])
    unless existing_name == ssh_user[:name]
      rename_user(existing_name, ssh_user[:name])
    end
  else
    setup_user(ssh_user.update(:uid => id))
  end
  set_public_key(ssh_user)
end

template '/etc/sudoers' do
  backup false
  source 'sudoers.erb'
  owner 'root'
  group 'root'
  mode 0440
  variables :sudoers => node[:sudoers]
end
