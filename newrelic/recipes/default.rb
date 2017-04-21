node[:deploy].each do |application, deploy|
  
  template "/etc/newrelic-infra.yml" do
    cookbook 'newrelic'
    source 'newrelic-infra.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :license_key => node[:newrelic][:license]
    )
  end

  template "/etc/yum.repos.d/newrelic-infra.repo" do
    cookbook 'newrelic'
    source 'newrelic-infra.repo.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
  end
end