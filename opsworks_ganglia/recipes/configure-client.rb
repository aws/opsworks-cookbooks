if node[:opsworks][:layers].has_key?('monitoring-master')
  include_recipe 'opsworks_ganglia::client'

  monitoring_master = node[:opsworks][:layers]['monitoring-master'][:instances].collect{ |instance, names|
    names['private_ip']
  }.first rescue nil

  service "gmond" do
    service_name value_for_platform_family("rhel" => "gmond", "debian" => "ganglia-monitor")
    action :nothing
    init_command "/usr/sbin/service ganglia-monitor" if platform?("ubuntu") && node[:platform_version] == "14.04"
    not_if { monitoring_master.nil? }
  end

  template '/etc/ganglia/gmond.conf' do
    source 'gmond.conf.erb'
    variables({
      :stack_name => node[:opsworks][:stack][:name],
      :monitoring_master => monitoring_master
    })

    notifies :restart, "service[gmond]"
    only_if do
      ::File.exists?('/etc/ganglia/gmond.conf')
    end
  end

  service "start/stop gmond depending if monitoring_master available" do
    service_name value_for_platform_family("rhel" => "gmond", "debian" => "ganglia-monitor")
    action(monitoring_master.nil? ? :stop : :start)
    init_command "/usr/sbin/service ganglia-monitor" if platform?("ubuntu") && node[:platform_version] == "14.04"
  end

  if node[:opsworks][:instance][:layers].any?{ |layer|
    ['php-app', 'monitoring-master'].include?(layer)
  } || (node[:opsworks][:instance][:layers].include?('rails-app') && node[:opsworks][:rails_stack][:name] == 'apache_passenger')

    Dir.glob("#{node[:apache][:log_dir]}/*-ganglia.log").each do |ganglia_log|
      cron "Ganglia Apache Monitoring #{ganglia_log}" do
        minute '*/2'
        command "/usr/sbin/ganglia-logtailer --classname ApacheLogtailer --log_file #{ganglia_log} --mode cron > /dev/null 2>&1"
      end
    end

  end
else
  Chef::Log.info 'No monitoring-master node found. Skipping Ganglia client configuration.'
end
