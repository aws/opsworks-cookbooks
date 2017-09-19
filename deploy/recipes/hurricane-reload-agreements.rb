include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].first(1).each do |application, deploy|

  execute 'rake agreement:reload' do
    Chef::Log.debug('Execute Rake Task To Reload All Agreements')
    cwd "#{deploy[:deploy_to]}/current"
    user deploy[:user]
    command 'bundle exec rake agreement:reload'
    environment 'RAILS_ENV' => deploy[:rails_env]
  end

end
