node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs-rollback for application #{application} as it is not a node.js app")
    next
  end

  deploy deploy[:deploy_to] do
    user deploy[:user]
    action 'rollback'
    restart_command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"

    only_if do
      File.exists?(deploy[:current_path])
    end
  end

  execute "restart node.js application #{application} via monit" do
    command "monit restart node_web_app_#{application}"
  end
end
