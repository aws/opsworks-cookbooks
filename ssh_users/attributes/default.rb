###
# Do not use this file to override the ssh_users cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "ssh_users/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'ssh_users/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

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

include_attribute "ssh_users::customize"
