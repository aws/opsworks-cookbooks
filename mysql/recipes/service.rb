service "mysql" do
  service_name value_for_platform([ "centos", "redhat", "suse" ] => {"default" => "mysqld"}, "default" => "mysql")

  case node[:platform]
  when "ubuntu"
    if node[:platform_version].to_f >= 10.04
      provider Chef::Provider::Service::Upstart
    end
  end
  supports :status => true, :restart => true, :reload => true
  action :nothing
end