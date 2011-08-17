define :scalarium_rails do
  deploy = params[:deploy_data]
  application = params[:app]

  include_recipe node[:scalarium][:rails_stack][:recipe]

  # write out memcached.yml
  template "#{deploy[:deploy_to]}/shared/config/memcached.yml" do
    cookbook "rails"
    source "memcached.yml.erb"
    mode "0660"
    owner deploy[:user]
    group deploy[:group]
    variables(:memcached => (deploy[:memcached] || {}), :environment => deploy[:rails_env])
  end

end 
