ruby_block 'Bindmounting RRDS directories for Ganglia' do
  block do
    Chef::Log.info("Bindmounting RRDS directories for Ganglia")
  end
end

directory "#{node[:ganglia][:datadir]}/rrds" do
  recursive true
  action :create
  mode "0775"
end

mount node[:ganglia][:original_datadir] do
  device node[:ganglia][:datadir]
  fstype "none"
  options "bind,rw"
  action :mount
end

mount node[:ganglia][:original_datadir] do
  device node[:ganglia][:datadir]
  fstype "none"
  options "bind,rw"
  action :enable
end