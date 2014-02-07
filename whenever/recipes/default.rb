include_recipe "deploy"

node[:deploy].each do |application, deploy|

  Chef::Log.info("Setting up cron job for #{application}...")

  Chef::Log.debug("Executing command:  bundle exec whenever --update-crontab '#{application}_#{deploy[:rails_env]}' in dir: #{File.join(deploy[:deploy_to], 'current')}")

  execute "rake whenever to update crontab" do
    user node[:deploy][application][:user]
    cwd "#{File.join(deploy[:deploy_to], 'current')}"
    command "bundle exec whenever --update-crontab #{application}_#{deploy[:rails_env]} --set environment=#{deploy[:rails_env]}"
    action :run
    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/current/config/schedule.rb")
    end
  end

  Chef::Log.info("Crontable has been updated successfully!")
end
