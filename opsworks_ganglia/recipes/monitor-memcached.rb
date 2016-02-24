case node["platform_family"]
when "rhel"
  package "perl-XML-Simple" do
    retries 3
    retry_delay 5
  end
  package "perl-Cache-Memcached" do
    retries 3
    retry_delay 5
  end
when "debian"
  package "libxml-simple-perl" do
    retries 3
    retry_delay 5
  end
  package "libcache-memcached-perl" do
    retries 3
    retry_delay 5
  end
end

template "/etc/ganglia/scripts/memcached" do
  source "ganglia_memcached.erb"
  owner "root"
  group "root"
  mode "0755"
end

cron 'Ganglia Memcached stats' do
  minute '*/2'
  command '/etc/ganglia/scripts/memcached > /dev/null 2>&1'
end
