
node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
  directory dir do
    recursive true
    action :create
    # TODO: something is changing the permissions on Ubuntu to 2750, who? and why?
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
