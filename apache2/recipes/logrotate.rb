template "/etc/logrotate.d/apache2" do
  backup false
  source "logrotate.erb"
  owner "root"
  group "root"
  mode 0644
end
