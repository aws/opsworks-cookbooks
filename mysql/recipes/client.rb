package 'mysql-devel' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'mysql-devel'},
    'ubuntu' => {'default' => 'libmysqlclient-dev'}
  )
  action :install
end

package 'mysql-client' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'mysql'},
    'default' => 'mysql-client'
  )
  action :install
end
