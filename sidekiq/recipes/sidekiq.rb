node[:deploy].each do |application, deploy|

  template "#{deploy[:current_path]}/config/variables.rb" do
    mode '0644'
    owner deploy[:user]
    group deploy[:group]
    source "sidekiq-variables.rb.erb"
    variables(
      :deploy => deploy,
      :application => application,
      :environment => OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
    )
  end

end
