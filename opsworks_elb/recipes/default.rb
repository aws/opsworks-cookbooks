include_recipe "opsworks_java"

java_home = node['aws']['elb']['java_home']

package "unzip" do
  action :install
end

directory "#{node['aws']['elb']['cli_install_path']}/elb" do
  group      "root"
  owner      "root"
  mode       0770
  action     :create
  recursive  true
end

bash "install-aws-elb-cli" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    rm -rf ElasticLoadBalancing-*
    rm -rf #{node['aws']['elb']['cli_install_path']}/elb
    unzip #{node['aws']['elb']['cli_download_filename']}
    rsync -a --no-o --no-g ElasticLoadBalancing-*/ #{node['aws']['elb']['cli_install_path']}/elb
  EOH
  action :nothing
end

remote_file File.join(Chef::Config[:file_cache_path], node['aws']['elb']['cli_download_filename']) do
  source node['aws']['elb']['cli_download_url']
  owner "root"
  mode 0644
  notifies :run, resources(:bash => "install-aws-elb-cli"), :immediately
  not_if "/usr/bin/env JAVA_HOME=#{java_home} AWS_ELB_HOME=#{node['aws']['elb']['cli_install_path']}/elb #{node['aws']['elb']['cli_install_path']}/elb/bin/elb-cmd version | grep #{node['aws']['elb']['cli_version']}"
end
