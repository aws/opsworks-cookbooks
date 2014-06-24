define :opsworks_rails do
  deploy = params[:deploy_data]

  include_recipe node[:opsworks][:rails_stack][:recipe]

  rails_install_dependencies "Install database dependencies for rails application #{params[:app].inspect}" do
    database_adapter OpsWorks::RailsConfiguration.determine_database_adapter(
      params[:app],
      deploy,
      "#{deploy[:deploy_to]}/current",
      :force => node[:force_database_adapter_detection]
    )
  end

  execute "symlinking subdir mount if necessary" do
    command "rm -f /var/www/#{deploy[:mounted_at]}; ln -s #{deploy[:deploy_to]}/current/public /var/www/#{deploy[:mounted_at]}"
    action :run
    only_if do
      deploy[:mounted_at] && File.exists?("/var/www")
    end
  end
end
