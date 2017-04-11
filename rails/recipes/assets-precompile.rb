include_recipe "deploy"

node[:deploy].each do |application, deploy|
 
  execute "cd #{deploy[:deploy_to]}/current && RAILS_ENV=#{deploy[:rails_env]} bundle exec rake assets:precompile > /dev/null"

end