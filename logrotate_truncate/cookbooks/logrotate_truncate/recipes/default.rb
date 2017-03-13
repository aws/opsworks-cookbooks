#
# Cookbook:: logrotate_truncate
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
template '/etc/truncate_logfiles.conf' do
	source 'truncate_logfiles.conf.erb'
end

template '/etc/truncate_logfile.sh' do
	source 'truncate_logfile.sh.erb'
	owner 'root'
	group 'root'
	mode '0755'
end

cron 'truncate_logs' do
	action :create
	minute '*/10'
	hour '*'
	weekday '*'
	user 'root'
	command '/etc/truncate_logfile.sh'
end
