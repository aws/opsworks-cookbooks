package 'postgresql-jdbc' do 
  package_name value_for_platform_family(
    'rhel' => 'postgresql-jdbc',
    'debian' => 'libpostgresql-jdbc-java'
  )
  action :install
end
