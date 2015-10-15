service "monit" do
  supports :status => false, :restart => true, :reload => true
  action :nothing
end


node[:deploy].each do |application, deploy|

  # Overwrite the unicorn restart command declared elsewhere
  # Apologies for the `sleep`, but monit errors with "Other action already in progress" on some boots.
  execute "restart Rails app #{application}" do
    command "sleep 60 && #{node[:sidekiq][application][:restart_command]}"
    action :nothing
  end

end
