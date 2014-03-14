###
# Do not use this file to override the opsworks_rubygems cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "opsworks_rubygems/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'opsworks_rubygems/attributes/rubygems.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'opsworks_initial_setup::default'

default['opsworks_rubygems']['version'] = '2.2.2'

# set LC_ALL and LANG to workaround US-ASCII errors with rubygems 2.0.3 on opsworks
case node['opsworks']['ruby_version']
when /1.8/
  default['opsworks_rubygems']['setup_command'] = "/usr/bin/env LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 /usr/local/bin/ruby setup.rb --no-rdoc --no-ri"
else
  # set --disable-gems for Ruby 1.9 and later
  default['opsworks_rubygems']['setup_command'] = "/usr/bin/env LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 /usr/local/bin/ruby --disable-gems setup.rb --no-rdoc --no-ri"
end

include_attribute "opsworks_rubygems::customize"
