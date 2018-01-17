include_recipe 'deploy'
Chef::Log.level = :debug


node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]

  execute "updating crontab" do
    user deploy[:user]
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle exec whenever -w -s environment=#{rails_env}"
    action :run
  end

end

