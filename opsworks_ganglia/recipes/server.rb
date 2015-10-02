include_recipe 'opsworks_ganglia::client'

case node[:platform_family]
when "rhel"
  package node[:ganglia][:gmetad_package_name]
  package node[:ganglia][:web_frontend_package_name]

when "debian"
  if platform?('ubuntu') && node[:platform_version] == '14.04'
    package node[:ganglia][:gmetad_package_name]
    package node[:ganglia][:web_frontend_package_name]
    package 'apache2-utils'
  else
    package 'librrd4'

    node[:ganglia][:web_frontend_dependencies].each do |web_frontend_dependency|
      package web_frontend_dependency
    end

    pm_helper = OpsWorks::PackageManagerHelper.new(node)

    [node[:ganglia][:gmetad_package_name], node[:ganglia][:web_frontend_package_name]].each do |package|
      current_package_info = pm_helper.summary(package)

      if current_package_info.version && current_package_info.version =~ /^#{node[:ganglia][:custom_package_version]}/
        Chef::Log.info("#{package} version is up-to-date (#{node[:ganglia][:custom_package_version]})")
      else

        packages_to_remove = pm_helper.installed_packages.select do |pkg, version|
          pkg.include?(package)
        end

        packages_to_remove.each do |pkg, version|
          package "Remove outdated package #{pkg}" do
            package_name pkg
            action :remove
          end
        end

        log "downloading" do
          message "Download and install #{package} version #{node[:ganglia][:custom_package_version]}"
          level :info

          action :nothing
        end

        opsworks_commons_assets_installer "Install ganglia component: #{package}" do
          asset package
          version node[:ganglia][:custom_package_version]

          notifies :write, "log[downloading]", :immediately
          action :install
        end
      end
    end
  end

end

execute "Ensure permission and ownership of web frontend" do
  command "chown -R #{node[:apache][:user]}:#{node[:apache][:group]} #{node[:ganglia][:web][:destdir]}"
end

include_recipe 'opsworks_ganglia::service-gmetad'

service 'gmetad' do
  action :stop
end

include_recipe 'opsworks_ganglia::bind-mount-data' if infrastructure_class?('ec2')

template '/etc/ganglia/gmetad.conf' do
  source 'gmetad.conf.erb'
  variables :stack_name => node[:opsworks][:stack][:name]
  mode "0644"
end

execute "fix permissions on ganglia rrds directory" do
 command "chown -R #{node[:ganglia][:rrds_user]}:#{node[:ganglia][:user]} #{node[:ganglia][:original_datadir]}/rrds"
end

include_recipe 'apache2::service'

service 'gmetad' do
  action [ :enable, :start ]
end
