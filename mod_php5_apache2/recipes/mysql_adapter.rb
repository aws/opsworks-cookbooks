package 'php-mysql' do
  package_name value_for_platform_family(
    'rhel' => 'php54-mysql',
    'debian' => 'php5-mysql'
  )
end
