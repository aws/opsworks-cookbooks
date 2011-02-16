require 'etc'

Etc.group do |entry|
  if entry.name == 'scalarium'
    default[:scalarium_gid] = entry.gid
  end
end

if node[:ssh_users]
  default[:sudoers] = node[:ssh_users].values.select {|user| user[:sudoer]}
else
  node[:sudoers] = []
end
