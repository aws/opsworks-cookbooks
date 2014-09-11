define :application_environment_file do

  template ::File.join(params[:path], "app.env") do
    source "app.env.erb"
    cookbook "opsworks_nodejs"
    mode 0770
    owner params[:user]
    group params[:group]
    variables(
      :environment => OpsWorks::Escape.escape_double_quotes(params[:environment_variables])
    )
    only_if { ::File.exists?(params[:path]) }
  end

end

