include_recipe 'runit'
include_recipe 'control_groups'

cookbook_file '/usr/local/bin/rc_mon_confine_proc' do
  source 'rc_mon_confine_proc'
  mode 0755
end
