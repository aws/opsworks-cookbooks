template "/etc/ganglia/conf.d/nginx_status.pyconf" do
  source "nginx_status.pyconf.erb"
  owner "root"
  group "root"
  mode '0644'
end

template "/etc/ganglia/python_modules/nginx_status.py" do
  source "nginx_status.py.erb"
  owner "root"
  group "root"
  mode "0755"
end