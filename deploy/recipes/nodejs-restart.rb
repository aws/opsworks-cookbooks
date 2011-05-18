include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs-restart for application #{application} as it is not a node.js app")
    next
  end

  execute "restart node.js application #{application} via monit" do
    command "monit restart node_web_app_#{application}"
  end
end
