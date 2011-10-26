package "python-mysqldb"

template "/etc/ganglia/conf.d/mysql.pyconf" do
  source "mysql.pyconf.erb"
  owner "root"
  group "root"
  mode '0644'
end

cookbook_file "/etc/ganglia/python_modules/mysql.py" do
  source "mysql.py"
  mode "0755"
end

cookbook_file "/etc/ganglia/python_modules/DBUtil.py" do
  source "DBUtil.py"
  mode "0755"
end