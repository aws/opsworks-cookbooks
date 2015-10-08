node[:deploy].each do |application, deploy|

  execute "restart Rails app #{application} for custom env" do
    cwd deploy[:current_path]
    node[:opsworks][:rails_stack][:restart_command]
    user deploy[:user]

    action :nothing
  end

end
