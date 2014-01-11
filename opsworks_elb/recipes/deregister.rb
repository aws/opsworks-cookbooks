include_recipe "opsworks-elb"

java_home = node['aws']['elb']['java_home']

execute "deregister" do
  command "/usr/bin/env JAVA_HOME=#{java_home} AWS_ELB_HOME=#{node['aws']['elb']['cli_install_path']}/elb #{node['aws']['elb']['cli_install_path']}/elb/bin/elb-cmd elb-deregister-instances-from-lb #{node[:aws][:elb][:load_balancer_name]} --instances '#{node[:opsworks][:instance][:aws_instance_id]}' --region #{node[:opsworks][:instance][:region]} --access-key-id '#{node['aws']['AWS_ACCESS_KEY_ID']}' --secret-key '#{node['aws']['AWS_SECRET_ACCESS_KEY']}'"
  user "root"
end