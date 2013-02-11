# dependencie for the memcached gem
package 'libmemcached development libraries' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'libmemcached-devel'},
    ['debian','ubuntu'] => {'default' => 'libmemcached-dev'}
  )
end

package 'libsasl2-dev' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'cyrus-sasl-devel'},
    ['debian','ubuntu'] => {'default' => 'libsasl2-dev'}
  )
end
