require 'resolv'
 
node[:deploy].each do |application, deploy|
  mysql_command = "/usr/bin/mysql -u #{deploy[:database][:username]} #{node[:mysql][:server_root_password].blank? ? '' : "-p#{node[:mysql][:server_root_password]}"}"
 
  execute "create mysql database" do
    command "#{mysql_command} -e 'CREATE DATABASE \'#{deploy[:database][:database]}\'' "
    action :run
  
    not_if do
      system("#{mysql_command} -e 'SHOW DATABASES' | egrep -e '^#{deploy[:database][:database]}$'")
    end
  end

  template "/tmp/grants.sql" do
    source 'grants.sql.erb'
    owner 'root'
    group 'root'
    mode '0600'
    variables :hosts => [], :settings => deploy[:database]
    cookbook "mysql"
    action :create
  end
 
  execute 'create grants' do
    command "#{mysql_command} < /tmp/grants.sql"
  end
end
