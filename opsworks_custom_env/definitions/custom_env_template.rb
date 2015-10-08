# Accepts:
#   application (application name)
#   deploy (hash of deploy attributes)
#   env (hash of custom environment settings)
# 
# Notifies a "restart Rails app <name> for custom env" resource.

define :custom_env_template do
  
  template "#{params[:deploy][:deploy_to]}/shared/.env" do
    source ".env.erb"
    owner params[:deploy][:user]
    group params[:deploy][:group]
    mode "0660"
    variables :env => params[:env]
    notifies :run, resources(:execute => "restart #{params[:application]} for custom env")

    only_if do
      File.exists?("#{params[:deploy][:deploy_to]}/shared/config")
    end
  end
  
end
