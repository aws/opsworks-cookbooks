node[:deploy].each do |application, deploy|

  execute "restart Rails app #{application} for custom env" do
    cwd deploy[:current_path]
    command "#{deploy[:deploy_to]}/shared/scripts/unicorn restart"
    user deploy[:user]

    action :nothing
  end

end
