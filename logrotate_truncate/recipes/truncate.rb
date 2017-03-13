#
# Cookbook:: logrotate_truncate
# Recipe:: truncate
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'truncate_logs' do
  command '/usr/bin/truncate_logrotate.sh'
end

