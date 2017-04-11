include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "notify newrelic" do
    cwd deploy[:current_path]
    environment ({'RAILS_ENV' => deploy[:rails_env]})
    command "bundle exec newrelic deployments"
  end
end
