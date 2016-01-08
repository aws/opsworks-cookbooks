
rails_env = node["deploy"]["staging_nca"]["rails_env"]

Chef::Log.info("RAILS_ENV ${rails_env}")


template "/tmp/cwlogs.cfg" do
  cookbook "awslogs"
  source "cwlogs.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:srvlog => node[:srvlog] )
end
