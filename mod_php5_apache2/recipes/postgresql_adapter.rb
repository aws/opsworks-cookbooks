package 'php-pgsql' do
  package_name value_for_platform_family(
    'rhel' => 'php54-pgsql',
    'debian' => 'php5-pgsql'
  )
end
