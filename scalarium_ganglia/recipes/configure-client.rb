service "gmond" do
  supports :status => false, :restart => false
  start_command "gmond"
  stop_command "pkill gmond"
  restart_command "pkill gmond; (sleep 60 && gmond) &" #ignore error if not running and start with 60s delay so that the monitoring node has our hostname configured when we connect
  action :nothing
end

monitoring_master = node[:scalarium][:roles]['monitoring-master'][:instances].collect{|instance, names| names["private_ip"]}.first rescue nil

template "/etc/ganglia/gmond.conf" do
  source "gmond.conf.erb"
  variables({
    :cluster_name => node[:scalarium][:cluster][:name],
    :monitoring_master => monitoring_master
  })
  
  notifies :restart, resources(:service => "gmond")
  only_if do
    File.exists?("/etc/ganglia/gmond.conf")
  end
end

if monitoring_master.nil?
  execute "Stop gmond if there is no monitoring master" do
    command "pkill gmond"
    only_if "pgrep gmond"
  end
end

if node[:scalarium][:instance][:roles].any?{|role| ['php-app', 'monitoring-master'].include?(role) } || (node[:scalarium][:instance][:roles].include?('rails-app') && node[:scalarium][:rails_stack][:name] == 'apache_passenger')
  Dir.glob("#{node[:apache][:log_dir]}/*-ganglia.log").each do |ganglia_log|
    cron "Ganglia Apache Monitoring #{ganglia_log}" do
      minute "*/2"
      command "/usr/sbin/ganglia-logtailer --classname ApacheLogtailer --log_file #{ganglia_log} --mode cron > /dev/null 2>&1"
    end
  end
end
