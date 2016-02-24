case node[:platform]
when 'centos','redhat','fedora','amazon','debian','ubuntu'
  package "ntp" do
    retries 3
    retry_delay 5
  end
end
