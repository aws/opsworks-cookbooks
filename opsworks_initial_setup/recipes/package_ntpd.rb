case node[:platform]
when 'centos','redhat','fedora','amazon','debian','ubuntu'
  package 'ntp'
end
