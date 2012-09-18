package "python-mysqldb" do
  case node[:platform]
  when "centos","redhat","fedora","scientific","amazon","oracle"
    package_name "MySQL-python"
  when "debian","ubuntu"
    package_name "python-mysqldb"
  end
end

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
