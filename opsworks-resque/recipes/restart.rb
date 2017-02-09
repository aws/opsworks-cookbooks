node[:deploy].each do |application, deploy|
  execute "cd #{deploy[:deploy_to]}/current && RAILS_ENV=#{deploy[:rails_env]} bundle exec rake restart_resque > /dev/null && restart resque-scheduler"
end
