if (node[:mysql][:ec2_path] && ! FileTest.directory?(node[:mysql][:ec2_path]))
  Chef::Log.info("Setting up the MySQL bind-mount to EBS")

  execute "Copy MySQL data to EBS for first init" do
    command "mv #{node[:mysql][:datadir]} #{node[:mysql][:ec2_path]} && mkdir -p #{node[:mysql][:datadir]} && rm -f #{node[:mysql][:ec2_path]}/ib_logfile*"
    not_if do
      FileTest.directory?(node[:mysql][:ec2_path])
    end
  end

  directory node[:mysql][:ec2_path] do
    owner "mysql"
    group "mysql"
  end

  mount node[:mysql][:datadir] do
    device node[:mysql][:ec2_path]
    fstype "none"
    options "bind,rw"
    action :mount
  end

  mount node[:mysql][:datadir] do
    device node[:mysql][:ec2_path]
    fstype "none"
    options "bind,rw"
    action :enable
  end

  execute "ensure MySQL data owned by MySQL user" do
    command "chown -R mysql:mysql #{node[:mysql][:datadir]}"
    action :run
  end

else
  Chef::Log.info("Skipping MySQL EBS setup - using what is already on the EBS volume")
end