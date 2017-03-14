#
# Cookbook:: logrotate_truncate
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node["opsworks"].nil? || node["opsworks"]["applications"].nil? then
	app_list = []
else
	app_list = node["opsworks"]["applications"]
end

if node["logtruncate"].nil? || node["logtruncate"]["paths"].nil? then
	path_list = []
else
	path_list = node["logtruncate"]["paths"]
end

template '/etc/truncate_logfiles.conf' do
	source 'truncate_logfiles.conf.erb'
	variables({
		apps: app_list,
		logpaths: path_list
	})
end

template '/usr/bin/truncate_logfile.sh' do
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
