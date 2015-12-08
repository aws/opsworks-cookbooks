include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  consts = Hash.new

  deploy[:environment_variables].each do |k, v|
    if k.match(/^PAYPAL_/)
      consts[k] = v
    end
    if k.match(/^URL_EV_MAIN/)
      consts[k] = v
    end
    if k.match(/^CHECKOUT_DOMAIN/)
      consts[k] = v
    end
    if k.match(/^ACTIVE_ITEM/)
      consts[k] = v
    end
    if k.match(/^MOIP_/)
      consts[k] = v
    end
  end

  directory "#{deploy[:deploy_to]}/shared/config/initializers/" do
    owner deploy[:user]
    group deploy[:group]
    recursive true
    action :create
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/checkout_constants.rb" do
    source "checkout_constants.rb.erb"
    cookbook 'checkout'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:cs => consts)

    only_if do
      ( consts.length >= 1 ) && File.directory?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end

  link "#{deploy[:deploy_to]}/current/config/initializers/checkout_constants.rb" do
    to "#{deploy[:deploy_to]}/shared/config/initializers/checkout_constants.rb"
    group deploy[:group]
    owner deploy[:user]
  end

end
