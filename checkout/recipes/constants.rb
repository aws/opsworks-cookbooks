include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  consts = Hash.new

  deploy[:environment_variables].each do |k, v|
    if k.match(/^PAYPAL_/)
      consts[k] = v
    end
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

end
