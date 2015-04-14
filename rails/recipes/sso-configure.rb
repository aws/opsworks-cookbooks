include_recipe "deploy"

node[:deploy].each do |application, deploy|

  template "#{deploy[:deploy_to]}/shared/config/cas.yml" do
    source "cas.yml.erb"
    cookbook 'rails'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:database => deploy[:database])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:database][:host].present? && File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end