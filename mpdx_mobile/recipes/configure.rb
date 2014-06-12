include_recipe "deploy"

deploy = node[:deploy]['mpdx_mobile']

template "#{deploy[:deploy_to]}/current/www/js/secure.js" do
  source "secure.js.erb"
  cookbook 'mpdx_mobile'
  mode "0660"
  group deploy[:group]
  owner deploy[:user]
  variables(:config => deploy[:config], :environment => deploy[:rails_env])
end

bash "npm install --production" do
  cwd "#{deploy[:deploy_to]}/current"
  code "npm install --production"
end

execute "sudo npm install -g grunt-cli" do

end

bash "grunt" do
  cwd "#{deploy[:deploy_to]}/current"
  code "grunt default imagemin"
end

