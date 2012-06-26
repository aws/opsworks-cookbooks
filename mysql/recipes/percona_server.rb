include_recipe "mysql::percona_repository"

if node[:percona][:version] =~ /^5\.5\..*/
  package 'libaio1'
end 

execute "Install Percona XtraDB Server" do
  cwd "#{node[:percona][:tmp_dir]}/#{node[:lsb][:release]}_#{node[:scalarium][:instance][:architecture]}"
  command "dpkg -i percona-server-server-*"
end

if node[:platform] == 'ubuntu' && node[:platform_version].to_f >= 10.04

  # is missing in Percona packages
  template "/etc/init/mysql.conf" do
    source "init.mysql.conf.erb"
    backup false
    owner "root"
    group "root"
    mode "0644"
    only_if do
      File.directory?("/etc/init/") && !File.exists?("/etc/init/mysql.conf")
    end
  end

  # Percona packages use old-style init script that doesn't work on Lucid as it doesn't use upstart
  execute "fix mysql init.d script on Lucid" do
    command "rm -f /etc/init.d/mysql && ln -s /lib/init/upstart-job /etc/init.d/mysql"
  end

  execute "kill any still running, old-style mysqld..." do
    command "killall mysqld"
    ignore_failure true
  end

end
