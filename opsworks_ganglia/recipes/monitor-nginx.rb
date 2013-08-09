template '/etc/ganglia/conf.d/nginx_status.pyconf' do
  source 'nginx_status.pyconf.erb'
  owner 'root'
  group 'root'
  mode 0644
end

template 'nginx_status.py' do
  path value_for_platform(
    ['centos','redhat','fedora','amazon'] => {
      'default' => "/usr/#{RUBY_PLATFORM.match(/64/) ? 'lib64' : 'lib'}/ganglia/python_modules/nginx_status.py"
      },
      ['debian','ubuntu'] => {'default' => '/usr/lib/ganglia/python_modules/nginx_status.py'}
    )
  source 'nginx_status.py.erb'
  owner 'root'
  group 'root'
  mode 0644
end
