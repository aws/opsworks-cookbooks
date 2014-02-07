#
# Cookbook Name:: sidekiq
# Recipe:: restart
#

node[:deploy].each do |application, deploy|
  execute "restart-sidekiq" do
    command %Q{
      echo "sleep 20 && monit -g sidekiq_#{application} restart all" | at now
    }
  end
end
