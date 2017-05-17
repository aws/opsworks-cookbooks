###
# Do not use this file to override the deploy cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "deploy/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'deploy/attributes/rails_stack.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

default[:opsworks][:ruby_stack][:name] = "nginx_unicorn"
case node[:opsworks][:ruby_stack][:name]
when "nginx_unicorn"
  normal[:opsworks][:ruby_stack][:recipe] = "unicorn::ruby"
  normal[:opsworks][:ruby_stack][:needs_reload] = true
  normal[:opsworks][:ruby_stack][:service] = 'unicorn'
  normal[:opsworks][:ruby_stack][:restart_command] = "../../shared/scripts/unicorn restart"
else
  raise "Unknown stack: #{node[:opsworks][:ruby_stack][:name].inspect}"
end

include_attribute "deploy::customize"
