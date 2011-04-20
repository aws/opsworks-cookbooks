package "libxml-simple-perl"
package "libcache-memcached-perl"

template "/etc/ganglia/scripts/memcached" do
  source "ganglia_memcached.erb"
  owner "root"
  group "root"
  mode '0744'
end

cron "Ganglia Memcached stats" do
  minute "*/2"
  command "/etc/ganglia/scripts/memcached > /dev/null 2>&1"
end