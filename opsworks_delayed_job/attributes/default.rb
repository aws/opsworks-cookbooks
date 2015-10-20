include_attribute "deploy"

default[:delayed_job] = {}
default[:delayed_job][:pool_size] = 4

case node[:platform_family]
when 'rhel', 'fedora', 'suse'
  default[:monit][:includes_dir] = '/etc/monit.d'
else
  default[:monit][:includes_dir] = '/etc/monit/conf.d'
end

node[:deploy].each do |application, deploy|

  default[:delayed_job][application] = {}
  default[:delayed_job][application][:path_to_script] = node[:delayed_job][:path_to_script] || 'bin'
  default[:delayed_job][application][:pools] = {}

  # Default to node[:delayed_job][:pool_size] workers, each with empty ({}) config.
  default[:delayed_job][application][:pools][:default] = Hash[node[:delayed_job][:pool_size].times.map{|i| [i.to_s, {}] }]

  # Use node[:delayed_job][application][:pools][HOSTNAME] if provided.
  default[:delayed_job][application][:pool] = node[:delayed_job][application][:pools][node[:opsworks][:instance][:hostname]] || node[:delayed_job][application][:pools][:default]
  Chef::Log.debug("Set delayed_job attributes for #{application} to #{node[:delayed_job][application].to_hash.inspect}")

  default[:delayed_job][application][:restart_command] = "sudo monit restart -g delayed_job_#{application}_group"

end

