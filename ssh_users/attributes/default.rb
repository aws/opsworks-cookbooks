require 'etc'

include_attribute 'opsworks_initial_setup::default'

Etc.group do |entry|
  if entry.name == 'opsworks'
    default[:opsworks_gid] = entry.gid
  end
end

if node[:ssh_users]
  default[:sudoers] = node[:ssh_users].values.select {|user| user[:sudoer]}
else
  default[:sudoers] = []
end
