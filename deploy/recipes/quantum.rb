include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|
  template "#{deploy[:deploy_to]}/shared/config/amazon.yml" do
    source 'quantum/amazon.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :etl_settings => node[:etl_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end
end