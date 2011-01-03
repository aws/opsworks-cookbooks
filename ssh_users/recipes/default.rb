group 'scalarium'

node[:ssh_users].each do |username, public_key|
  user username do
    action :create
    comment "Scalarium user #{username}"
    gid 'scalarium'
    home "/home/#{username}"
    supports :manage_home => true
    shell '/bin/zsh'
  end

  # setting owner directly results in: Option owner's value daniel.huesch does not match regular expression (?-mix:^([a-z]|[A-Z]|[0-9]|_|-)+$)(?-mix:^\d+$) (ArgumentError)
  directory "/home/#{username}/.ssh"

  template "/home/#{username}/.ssh/authorized_keys" do
    cookbook 'ssh_users'
    source 'authorized_keys.erb'
    group 'scalarium'
    variables(:public_key => public_key)
  end

  ruby_block "work around chef's user name limitation" do
    block do
      `chown #{username}:scalarium /home/#{username}/.ssh`
      `chmod 700 /home/#{username}/.ssh`
      `chown #{username}:scalarium /home/#{username}/.ssh/authorized_keys`
      `chmod 600 /home/#{username}/.ssh/authorized_keys`
    end
  end
end
