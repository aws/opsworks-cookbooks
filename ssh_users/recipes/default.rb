group 'scalarium'

node[:ssh_users].each do |username, public_key|
  user username do
    action :create
    comment "Scalarium user #{username}"
    gid 'scalarium-users'
    home "/home/#{username}"
    supports :manage_home => true
    shell '/bin/zsh'
  end

  directory "/home/#{username}/.ssh"

  template "/home/#{username}/.ssh/authorized_keys" do
    cookbook 'ssh_users'
    source 'authorized_keys.erb'
    mode 600
    group 'scalarium'
    variables(:public_key => public_key)
  end
end
