action :create do
  execute "Restart Rails App #{new_resource.application}" do
    cwd "#{new_resource.deploy_to}/current"
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  template "#{new_resource.deploy_to}/shared/config/database.yml" do
    source "database.yml.erb"
    cookbook "rails"
    mode "0660"
    group new_resource.group
    owner new_resource.user
    variables(
      :database => new_resource.database_data,
      :environment => new_resource.rails_env
    )

    notifies :run, "execute[Restart Rails App #{new_resource.application}]" if new_resource.restart

    only_if do
      new_resource.database_data[:host].present?
    end
  end.run_action(:create)

  template "#{new_resource.deploy_to}/shared/config/memcached.yml" do
    source "memcached.yml.erb"
    cookbook "rails"
    mode "0660"
    group new_resource.group
    owner new_resource.user
    variables(
      :memcached => new_resource.memcached_data,
      :environment => new_resource.rails_env
    )

    notifies :run, "execute[Restart Rails App #{new_resource.application}]" if new_resource.restart

    only_if do
      new_resource.memcached_data[:host].present?
    end
  end.run_action(:create)
end
