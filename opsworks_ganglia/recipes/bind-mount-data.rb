directory "#{node[:ganglia][:datadir]}/rrds" do
  owner node[:ganglia][:rrds_user]
  mode 0775
  recursive true
  action :create
end

mount node[:ganglia][:original_datadir] do
  Chef::Log.info('Bind-mounting RRDS directories for Ganglia')
  device node[:ganglia][:datadir]
  fstype 'none'
  options 'bind,rw'
  action [:mount, :enable]
end
