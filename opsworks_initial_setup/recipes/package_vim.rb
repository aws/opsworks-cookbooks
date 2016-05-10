case node[:platform]
when 'debian','ubuntu'
  package "vim-nox" do
    retries 3
    retry_delay 5
  end
when 'centos','redhat','fedora','amazon'
  package "vim-enhanced" do
    retries 3
    retry_delay 5
  end
end
