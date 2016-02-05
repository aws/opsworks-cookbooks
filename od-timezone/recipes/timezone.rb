template "/etc/sysconfig/clock" do
  cookbook "od-timezone"      
  source "clock.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:clock => node[:timezone][:clock])
end

link "/etc/localtime" do
  to "/usr/share/zoneinfo/Brazil/East"
  action :create
end

template "/etc/cron.daily/ntpdate" do
  cookbook "od-timezone"      
  source "ntpdate.erb"
  mode 0755
  owner "root"
  group "root"
  variables(:ntpdate => node[:timezone][:ntpdate])
end
