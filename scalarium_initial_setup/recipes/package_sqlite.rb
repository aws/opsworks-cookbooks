case node[:platform]
when 'centos','redhat','fedora','amazon'
  package 'sqlite-devel'
end
