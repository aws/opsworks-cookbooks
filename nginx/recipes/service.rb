# Cookbook Name:: nginx
# Recipe:: service

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
