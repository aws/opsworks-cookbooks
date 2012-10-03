case node[:platform]
when 'centos','redhat','amazon','scientific','oracle','fedora'
  package 'sqlite-devel'
end
