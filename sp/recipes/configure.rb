include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  directory "#{deploy[:deploy_to]}" do
    action :create
    recursive true
    mode "0775"
    group deploy[:group]
    owner deploy[:user]
  end


  directory "#{deploy[:deploy_to]}/shared" do
    action :create
    recursive true
    mode "0775"
    group deploy[:group]
    owner deploy[:user]
  end

  directory "#{deploy[:deploy_to]}/shared/config" do
    action :create
    recursive true
    mode "0775"
    group deploy[:group]
    owner deploy[:user]
  end

  directory "#{deploy[:deploy_to]}/shared/config/initializers" do
    action :create
    recursive true
    mode "0775"
    group deploy[:group]
    owner deploy[:user]
  end

  template "#{deploy[:deploy_to]}/shared/config/config.yml" do
    source "config.yml.erb"
    cookbook 'sp'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:config => deploy[:config], :environment => deploy[:rails_env])
  end

  template "#{deploy[:deploy_to]}/shared/config/redis.yml" do
    source "redis.yml.erb"
    cookbook 'sp'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:redis => deploy[:redis] || {}, :environment => deploy[:rails_env])
  end
  
  template "#{deploy[:deploy_to]}/shared/config/amazon_s3.yml" do
    source "amazon_s3.yml.erb"
    cookbook 'sp'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:amazon => deploy[:amazon] || {}, :environment => deploy[:rails_env])
  end

  template "#{deploy[:deploy_to]}/shared/config/facebook.yml" do
    source "facebook.yml.erb"
    cookbook 'sp'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:facebook => deploy[:facebook] || {}, :environment => deploy[:rails_env])
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/smtp.rb" do
    source "smtp.rb.erb"
    cookbook 'sp'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:smtp => deploy[:smtp] || {}, :environment => deploy[:rails_env])
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/active_merchant.rb" do
    source "active_merchant.rb.erb"
    cookbook 'sp'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:authnet => deploy[:authnet] || {}, :environment => deploy[:rails_env])
  end
end
