include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].first(1).each do |application, deploy|

  execute 'rake offers:generate_all' do
    Chef::Log.debug('Execute Rake Task To Reload All Offers')
    cwd "#{deploy[:deploy_to]}/current"
    user deploy[:user]
    command 'bundle exec rake offers:generate_all'
    environment 'RAILS_ENV' => deploy[:rails_env]
  end

end
