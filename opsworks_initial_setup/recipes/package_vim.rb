case node[:platform]
when 'debian','ubuntu'
  package 'vim-nox'
when 'centos','redhat','fedora','amazon'
  package 'vim-enhanced'
end
