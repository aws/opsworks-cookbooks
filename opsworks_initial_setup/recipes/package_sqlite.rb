case node[:platform]
when 'centos','redhat','fedora','amazon'
  package "sqlite-devel" do
    retries 3
    retry_delay 5
  end
end
