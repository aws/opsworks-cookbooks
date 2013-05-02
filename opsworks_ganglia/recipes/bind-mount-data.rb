directory "#{node[:ganglia][:datadir]}/rrds" do
  owner node[:ganglia][:rrds_user]
  mode 0775
  recursive true
  action :create
end

# TODO: after Chef upgrade use Chef::Util::FileEdit
bash "adding bind mount for #{node[:ganglia][:original_datadir]} to #{node[:ganglia][:opsworks_autofs_map_file]}" do
  user 'root'
  code <<-EOC
    if ! grep -q #{node[:ganglia][:original_datadir]} #{node[:ganglia][:opsworks_autofs_map_file]}; then
      echo "#{node[:ganglia][:original_datadir]} -fstype=none,bind,rw :#{node[:ganglia][:datadir]}" >> #{node[:ganglia][:opsworks_autofs_map_file]}
    fi
  EOC
end
