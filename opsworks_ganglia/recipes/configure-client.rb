service 'gmond' do
  case node[:platform]
  when 'ubuntu'
    start_command '/etc/init.d/ganglia-monitor start'
    stop_command '/etc/init.d/ganglia-monitor stop'
    restart_command '/etc/init.d/ganglia-monitor restart'
  when 'centos','redhat','fedora','amazon'
    start_command '/etc/init.d/gmond start'
    stop_command '/etc/init.d/gmond stop'
    restart_command '/etc/init.d/gmond restart'
  end

  supports :status => false, :restart => false
  action :nothing
end

monitoring_master = node[:opsworks][:layers]['monitoring-master'][:instances].collect{ |instance, names|
  names['private_ip']
}.first rescue nil

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

execute 'Stop gmond if there is no monitoring master' do
  command 'pkill gmond'
  only_if { monitoring_master.nil? && system('pgrep gmond') }
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
