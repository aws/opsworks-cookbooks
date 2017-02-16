include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|
  yum_repository 'Postgres 9.6 Repo' do
    description "Postgres 9.6 Repo"
    baseurl "https://download.postgresql.org/pub/repos/yum/srpms/9.6/redhat/rhel-6-$basearch"
    repo_gpgcheck false
    action :create
  end


  execute "updating crontab" do
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec whenever -w -s environment=#{deploy[:env]}"
    action :run
  end

  template "#{deploy[:deploy_to]}/shared/config/settings.yml" do
    source 'lumen_etl/settings.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :etl_settings => node[:etl_settings],
        :etl_env => deploy[:env]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end
end
