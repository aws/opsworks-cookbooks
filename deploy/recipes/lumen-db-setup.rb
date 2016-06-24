include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  Chef::Log.info("Stopping Unicorn...")

  execute "stop unicorn" do
    command "#{deploy[:deploy_to]}/shared/scripts/unicorn stop"
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/scripts/unicorn")
    end
  end

  Chef::Log.info("Rails Db Setup...")

  execute 'bin/rake db:drop db:create db:migrate' do
    cwd current_path
    user 'deploy'
    command 'bin/rake db:drop db:create db:migrate'
    environment 'RAILS_ENV' => rails_env
  end

  Chef::Log.info("Start Unicorn...")

  execute "start unicorn" do
    command "#{deploy[:deploy_to]}/shared/scripts/unicorn start"
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/scripts/unicorn")
    end
  end



end