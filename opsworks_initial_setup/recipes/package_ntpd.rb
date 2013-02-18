case node[:platform]
when 'centos','redhat','fedora','amazon'
  package 'ntp'
when 'debian','ubuntu'
  package 'openntpd'
end
