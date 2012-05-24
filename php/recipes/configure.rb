node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  # write out scalarium.php
  template "#{deploy[:deploy_to]}/shared/config/scalarium.php" do
    cookbook 'php'
    source 'scalarium.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(:database => deploy[:database], :memcached => deploy[:memcached], :roles => node[:scalarium][:roles], :cluster_name => node[:scalarium][:cluster][:name])
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end
end
