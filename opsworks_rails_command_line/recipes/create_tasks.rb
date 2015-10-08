
node[:deploy].each do |_, deploy|

  escaped_env_vars = OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
  env_string = escaped_env_vars.collect { |key, value| %Q{#{key}="#{value}"} }.join(' ')

  template "#{deploy[:deploy_to]}/current/lib/tasks/rails_console.rake" do
    owner deploy[:user]
    group deploy[:group]
    mode 0644
    source "rails_console_task.rb.erb"
    variables({
                  :env_vars => env_string
              })
  end

  env_string += " RAILS_ENV=production "

  template "#{deploy[:deploy_to]}/current/lib/tasks/with_env.rake" do
    owner deploy[:user]
    group deploy[:group]
    mode 0644
    source "rake_with_env.rb.erb"
    variables({
                  :env_vars => env_string,
                  :rails_env => deploy[:rails_env]
              })
  end
end