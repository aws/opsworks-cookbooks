if node[:opsworks][:layers].has_key?('monitoring-master')
  case node[:platform_family]
  when "debian"
    if platform?('ubuntu') && node[:platform_version] == '14.04'
      package node[:ganglia][:monitor_package_name]
      package node[:ganglia][:monitor_plugins_package_name]
    else
      package 'libapr1'
      package 'libconfuse0'

      pm_helper = OpsWorks::PackageManagerHelper.new(node)

      [node[:ganglia][:libganglia_package_name], node[:ganglia][:monitor_package_name], node[:ganglia][:monitor_plugins_package_name]].each do |package|
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

  when "rhel"
    package node[:ganglia][:monitor_package_name]
    package node[:ganglia][:monitor_plugins_package_name]
  end

  service "gmond" do
    service_name value_for_platform_family("rhel" => "gmond", "debian" => "ganglia-monitor")
    action :stop
    init_command "/usr/sbin/service ganglia-monitor" if platform?("ubuntu") && node[:platform_version] == "14.04"
  end

  # old broken installations have this empty directory
  # new working ones have a symlink
  directory "/etc/ganglia/python_modules" do
    action :delete
    not_if { ::File.symlink?("/etc/ganglia/python_modules")}
  end

  link "/etc/ganglia/python_modules" do
    to value_for_platform_family(
      "debian" => "/usr/lib/ganglia/python_modules",
      "rhel" => "/usr/lib#{RUBY_PLATFORM[/64/]}/ganglia/python_modules"
    )
  end

  execute "Normalize ganglia plugin permissions" do
    command "chmod 644 /etc/ganglia/python_modules/*"
  end

  ['scripts','conf.d'].each do |dir|
    directory "/etc/ganglia/#{dir}" do
      action :create
      owner "root"
      group "root"
      mode "0755"
    end
  end

  include_recipe 'opsworks_ganglia::monitor-fd-and-sockets'
  include_recipe 'opsworks_ganglia::monitor-disk'

  node[:opsworks][:instance][:layers].each do |layer|
    case layer
    when 'memcached'
      include_recipe 'opsworks_ganglia::monitor-memcached'
    when 'db-master'
      include_recipe 'opsworks_ganglia::monitor-mysql'
    when 'lb'
      include_recipe 'opsworks_ganglia::monitor-haproxy'
    when 'php-app','monitoring-master'
      include_recipe 'opsworks_ganglia::monitor-apache'
    when 'web'
      include_recipe 'opsworks_ganglia::monitor-nginx'
    when 'rails-app'

      case node[:opsworks][:rails_stack][:name]
      when 'apache_passenger'
        include_recipe 'opsworks_ganglia::monitor-passenger'
        include_recipe 'opsworks_ganglia::monitor-apache'
      when 'nginx_unicorn'
        include_recipe 'opsworks_ganglia::monitor-nginx'
      end

    end
  end
else
  Chef::Log.info 'No monitoring-master node found. Skipping Ganglia client setup.'
end
