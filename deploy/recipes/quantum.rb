include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  template "#{deploy[:deploy_to]}/shared/config/amazon.yml" do
    source 'quantum/amazon.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :quantum_settings => node[:quantum_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "#{deploy[:deploy_to]}/shared/config/secrets.yml" do
    source 'quantum/secrets.yml.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :quantum_settings => node[:quantum_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  execute "create initializiers directory in shared/config" do
    command "mkdir -p #{deploy[:deploy_to]}/shared/config/initializers/"
  end

  template "#{deploy[:deploy_to]}/shared/config/initializers/aws.rb" do
    source 'quantum/aws.rb.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :quantum_settings => node[:quantum_settings]
    )
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/initializers")
    end
  end
end