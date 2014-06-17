package 'mysql-connector-java' do 
  package_name value_for_platform_family(
    'rhel' => 'mysql-connector-java',
    'debian' => 'libmysql-java'
  )
  action :install
end
