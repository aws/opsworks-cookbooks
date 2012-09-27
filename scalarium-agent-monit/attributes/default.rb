case node[:platform]
when 'centos','amazon','redhat','fedora','scientific','oracle'
  default[:monit][:conf]     = '/etc/monit.conf'
  default[:monit][:conf_dir] = '/etc/monit.d'
when 'debian','ubuntu'
  default[:monit][:conf]     = '/etc/monit/monitrc'
  default[:monit][:conf_dir] = '/etc/monit/conf.d'
end
