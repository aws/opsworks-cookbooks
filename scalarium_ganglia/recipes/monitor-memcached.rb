package "libxml-simple-perl" do
  case node[:platform]
  when "centos","redhat","fedora","scientific","amazon","oracle"
    package_name "perl-XML-Simple"
  when "debian","ubuntu"
    package_name "libxml-simple-perl"
  end
end
package "libcache-memcached-perl" do
  case node[:platform]
  when "centos","redhat","fedora","scientific","amazon","oracle"
    package_name "perl-Cache-Memcached"
  when "debian","ubuntu"
    package_name "libcache-memcached-perl"
  end
end

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
