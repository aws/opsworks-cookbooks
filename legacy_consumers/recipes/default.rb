
node[:deploy].each do |app_name, deploy|
  Chef::Log.info deploy

  directory "#{deploy[:home]}/.ssh" do
    owner deploy[:user]
    mode 0755
  end

  directory "#{deploy[:deploy_to]}/shared" do
    owner deploy[:user]
    group "root"
    mode 0755
    recursive true
  end

  directory "#{deploy[:deploy_to]}/shared/log" do
    owner deploy[:user]
    group "root"
    mode 0755
    recursive true
  end


  directory "#{deploy[:deploy_to]}/shared/config" do
    owner deploy[:user]
    group "root"
    mode 0755
    recursive true
  end

  template "#{deploy[:home]}/.ssh/myapp_deploy_key" do
    source "ssh_deploy_key.erb"
    owner deploy[:user]
    group 'www-data'
    mode 0400
    variables({ :ssh_key_data => deploy[:scm][:ssh_key] })
  end

  template "/tmp/myapp_deploy_wrapper.sh" do
    source "ssh_wrapper.sh.erb"
    owner deploy[:user]
    group "www-data"
    mode 0755
    variables({
      :ssh_key_path => "#{deploy[:home]}/.ssh/myapp_deploy_key"
    })
  end

  deploy_revision "#{deploy[:deploy_to]}" do
    repository deploy[:scm][:repository]
    revision deploy[:scm][:revision]
    ssh_wrapper "/tmp/myapp_deploy_wrapper.sh"
  end
  execute "cp  #{deploy[:deploy_to]}/shared/cached-copy/config/database.yml #{deploy[:deploy_to]}/shared/config/"
  execute "gem install bundler && cd #{deploy[:deploy_to]}/current && bundle install"

end

