define :nginx_site, :template => "site.erb", :enable => true do
  application = params[:application]
  application_name = params[:name]

  Chef::Log.debug("The \"nginx_site\" will be deprecated, please use nginx_web_app instead.")

  nginx_web_app do
    application application
    application_name application_name
    cookbook "nginx"
  end
end
