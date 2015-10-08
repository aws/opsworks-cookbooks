node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  Chef::Log.info("Reindexes search data with environment #{rails_env}")

  execute "rake searchkick:reindex:all" do
    cwd current_path
    user 'deploy'
    command "bundle exec rake searchkick:reindex:all"
    environment 'RAILS_ENV' => rails_env
  end
end
