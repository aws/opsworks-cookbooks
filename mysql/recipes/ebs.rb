if (node[:mysql][:ec2_path] && ! FileTest.directory?(node[:mysql][:ec2_path]))
  Chef::Log.info("Setting up the MySQL bind-mount to EBS")

  execute "Copy MySQL data to EBS for first init" do
    command "mv #{node[:mysql][:datadir]} #{node[:mysql][:ec2_path]} && mkdir -p #{node[:mysql][:datadir]} && rm -f #{node[:mysql][:ec2_path]}/ib_logfile*"
    not_if do
      FileTest.directory?(node[:mysql][:ec2_path])
    end
  end

  directory node[:mysql][:ec2_path] do
    owner node[:mysql][:user]
    group node[:mysql][:group]
  end

  execute "ensure MySQL data owned by MySQL user" do
    command "chown -R #{node[:mysql][:user]}:#{node[:mysql][:group]} #{node[:mysql][:datadir]}"
    action :run
  end

else
  Chef::Log.info("Skipping MySQL EBS setup - using what is already on the EBS volume")
end

ruby_block "adding bind mount for #{node[:mysql][:datadir]} to #{node[:mysql][:opsworks_autofs_map_file]}" do
  block do
    handle_to_map_file = Chef::Util::FileEdit.new(node[:mysql][:opsworks_autofs_map_file])
    handle_to_map_file.insert_line_if_no_match(node[:mysql][:datadir], node[:mysql][:autofs_entry])
    handle_to_map_file.write_file
  end

  notifies :restart, "service[autofs]", :immediately
end

execute "ensure MySQL logdir is owned by MySQL user (even if mounted by autofs)" do
  command "service autofs restart && sleep 2; ls -l #{node[:mysql][:logdir]} && chown -R #{node[:mysql][:user]}:#{node[:mysql][:group]} #{node[:mysql][:logdir]}"
  action :run
end
