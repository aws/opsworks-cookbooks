node[:deploy].each do |application, deploy|
  
  template "/etc/newrelic-infra.yml" do
    cookbook 'newrelic'
    source 'newrelic-infra.yml.erb'
    mode '0660'
    owner 'root'
    group 'root'
    variables(
      :license_key => node[:newrelic][:license],
      :environment => node[:newrelic][:environment]
    )
  end

  template "/etc/yum.repos.d/newrelic-infra.repo" do
    cookbook 'newrelic'
    source 'newrelic-infra.repo.erb'
    mode '0660'
    owner 'root'
    group 'root'
  end

  execute "update yum cache" do
    Chef::Log.debug("newrelic::update yum cache")
    command "yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'"
  end

  execute "install newrelic-infra" do
    Chef::Log.debug("newrelic::installing newrelic-infra")
    command "sudo yum install newrelic-infra -y"
  end

end