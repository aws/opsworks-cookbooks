include_attribute 'opsworks_initial_setup::default'

default['opsworks_rubygems']['version'] = '2.1.7'

# set LC_ALL and LANG to workaround US-ASCII errors with rubygems 2.0.3 on opsworks
case node['opsworks']['ruby_version']
when /1.8/
  default['opsworks_rubygems']['setup_command'] = "/usr/bin/env LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 /usr/local/bin/ruby setup.rb --no-rdoc --no-ri"
else
  # set --disable-gems for Ruby 1.9 and later
  default['opsworks_rubygems']['setup_command'] = "/usr/bin/env LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 /usr/local/bin/ruby --disable-gems setup.rb --no-rdoc --no-ri"
end
