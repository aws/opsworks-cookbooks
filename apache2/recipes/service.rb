service 'apache2' do
  service_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'httpd'},
    ['debian','ubuntu'] => {'default' => 'apache2'}
  )

  # If restarted/reloaded too quickly httpd has a habit of failing.
  # This may happen with multiple recipes notifying apache to restart - like
  # during the initial bootstrap.
  ['restart','reload'].each do |srv_cmd|
    send("#{srv_cmd}_command", value_for_platform(
        ['centos','redhat','fedora','amazon'] => {
          'default' => "sleep 1 && /sbin/service httpd #{srv_cmd} && sleep 1"
        },
        ['debian','ubuntu'] => {
          'default' => "sleep 1 && /etc/init.d/apache2 #{srv_cmd} && sleep 1"
        }
      )
    )
  end

  supports value_for_platform(
    'debian' => {
      '4.0' => [:restart, :reload],
      'default' => [:restart, :reload, :status]
    },
    'ubuntu' => { 'default' => [:restart, :reload, :status] },
    ['centos','redhat','fedora','amazon'] => { 'default' => [:restart, :reload, :status] },
    'default' => { 'default' => [:restart, :reload] }
  )

  action :nothing
end
