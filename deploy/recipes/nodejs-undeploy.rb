include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs-undeploy for application #{application} as it is not a node.js app")
    next
  end

  execute "stop node.js application #{application} via monit" do
    command "monit stop node_web_app_#{application}"
  end

  file "/etc/monit/conf.d/node_web_app-#{application}.monitrc" do
    action :delete
    only_if do
      File.exists?("/etc/monit/conf.d/node_web_app-#{application}.monitrc")
    end
  end

  directory "#{deploy[:deploy_to]}" do
    recursive true
    action :delete

    only_if do
      File.exists?("#{deploy[:deploy_to]}")
    end
  end
end
