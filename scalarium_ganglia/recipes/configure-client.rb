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

monitoring_master = node[:scalarium][:roles]['monitoring-master'][:instances].collect{ |instance, names|
  names['private_ip']
}.first rescue nil

template '/etc/ganglia/gmond.conf' do
  source 'gmond.conf.erb'
  variables({
    :cluster_name => node[:scalarium][:cluster][:name],
    :monitoring_master => monitoring_master
  })

  notifies :restart, resources(:service => 'gmond')
  only_if do
    File.exists?('/etc/ganglia/gmond.conf')
  end
end

if monitoring_master.nil?
  execute 'Stop gmond if there is no monitoring master' do
    command 'pkill gmond'
    only_if 'pgrep gmond'
  end
end

if node[:scalarium][:instance][:roles].any?{ |role|
  ['php-app', 'monitoring-master'].include?(role)
} || (node[:scalarium][:instance][:roles].include?('rails-app') && node[:scalarium][:rails_stack][:name] == 'apache_passenger')

  Dir.glob("#{node[:apache][:log_dir]}/*-ganglia.log").each do |ganglia_log|
    cron "Ganglia Apache Monitoring #{ganglia_log}" do
      minute '*/2'
      command "/usr/sbin/ganglia-logtailer --classname ApacheLogtailer --log_file #{ganglia_log} --mode cron > /dev/null 2>&1"
    end
  end

end
