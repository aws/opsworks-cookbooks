node[:deploy].each do |application, deploy|
  execute "cd #{deploy[:deploy_to]}/current && RAILS_ENV=#{deploy[:rails_env]} bundle exec rake restart_resque > /dev/null"
  
  service "resque-#{application}" do
    supports :status => true, :restart => true, :start => true
    provider Chef::Provider::Service::Upstart
    action [ :start ]
  end
end
