# dependencie for the memcached gem
package "libmemcached development libraries" do
  package_name value_for_platform_family(
    "rhel" => "libmemcached-devel",
    "debian" => "libmemcached-dev"
  )
end.run_action(:install)

package 'libsasl2-dev' do
  package_name value_for_platform_family(
    "rhel" => "cyrus-sasl-devel",
    "debian" => "libsasl2-dev"
  )
end.run_action(:install)

chef_gem "memcached" do
  version node[:memcached][:testing][:gem_version]
  options "--no-ri --no-rdoc"
  action :install
end

require "memcached"
