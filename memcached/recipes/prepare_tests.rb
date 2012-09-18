# dependencie for the memcached gem
package "libmemcached-dev" do
  case node[:platform]
  when "centos","fedora","amazon","redhat","scientific","oracle"
    package_name "libmemcached-devel"
  when "debian","ubuntu"
    package_name "libmemcached-dev"
  end
end

package "libsasl2-dev" do
  case node[:platform]
  when "centos","fedora","amazon","redhat","scientific","oracle"
    package_name "cyrus-sasl-devel"
  when "debian","ubuntu"
    package_name "libsasl2-dev"
  end
end
