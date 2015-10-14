# to mix into Chef::Recipe
module FollowLogs
	# Follow a list of logs from the JSON config file 
	def follow_logs()
		logs = node[:le][:logs_to_follow]
		logs.each do |log|
			follow(log)
		end
	end
	
	# Script to follow a log
	def follow(log)
		execute "le follow '#{log}'"
	end
end