include_recipe "mysql::percona_repository"

execute "Install Percona XtraDB Server" do
  cwd "#{node[:percona][:tmp_dir]}/#{node[:scalarium][:instance][:architecture]}"
  command "dpkg -i percona-server-server-*"
end