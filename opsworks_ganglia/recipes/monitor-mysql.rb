package 'python mysql support' do
  package_name value_for_platform_family(
    "rhel" => 'MySQL-python',
    "debian" => 'python-mysqldb'
  )
  retries 3
  retry_delay 5
end

template '/etc/ganglia/conf.d/mysql.pyconf' do
  source 'mysql.pyconf.erb'
  owner 'root'
  group 'root'
  mode "0644"
end
