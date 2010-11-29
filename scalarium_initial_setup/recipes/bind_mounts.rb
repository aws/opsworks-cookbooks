
node[:scalarium_initial_setup][:bind_mounts][:mounts].each do |dir, source|
  directory dir do
    recursive true
    action :create
    mode "0755"
  end

  directory source do
    recursive true
    action :create
    mode "0755"
  end

  mount dir do
    device source
    fstype "none"
    options "bind,rw"
    action :mount
  end

  mount dir do
    device source
    fstype "none"
    options "bind,rw"
    action :enable
  end
end