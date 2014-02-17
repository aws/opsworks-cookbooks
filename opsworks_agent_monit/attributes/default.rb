###
# Do not use this file to override the opsworks_agent_monit cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "opsworks_agent_monit/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'opsworks_agent_monit/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'opsworks_initial_setup::default'

case node[:platform]
when 'centos','redhat','fedora','suse','amazon'
  default[:monit][:conf]     = '/etc/monit.conf'
  default[:monit][:conf_dir] = '/etc/monit.d'
when 'debian','ubuntu'
  default[:monit][:conf]     = '/etc/monit/monitrc'
  default[:monit][:conf_dir] = '/etc/monit/conf.d'
end

include_attribute "opsworks_agent_monit::customize"
