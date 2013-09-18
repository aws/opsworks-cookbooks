template "/etc/ganglia/conf.d/nginx_status.pyconf" do
  source "nginx_status.pyconf.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "nginx_status.py" do
  path value_for_platform_family(
      "rhel" => "/usr/lib#{RUBY_PLATFORM[/64/]}/ganglia/python_modules/nginx_status.py",
      "debian" => '/usr/lib/ganglia/python_modules/nginx_status.py'
    )
  source "nginx_status.py.erb"
  owner "root"
  group "root"
  mode "0644"
end
