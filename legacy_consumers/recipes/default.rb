include_recipe "deploy"
#include_recipe "deploy_wrapper"

node[:deploy].each do |app_name, deploy|
  Chef::Log.info deploy

#  directory "#{deploy[:home]}/.ssh" do
#    mode 0750
#    owner deploy[:user]
#  end

#  f = File.new("#{deploy[:home]}/.ssh/id_deploy", File::CREAT|File::TRUNC|File::RDWR, 0600)
#  f.write deploy[:scm][:ssh_key]
#  f.close
#  `chown deploy. "#{deploy[:home]}/.ssh/id_deploy"`

#  template "#{deploy[:home]}/chef_ssh_deploy_wrapper.sh" do
#    source "chef_ssh_deploy_wrapper.sh.erb"
#    owner deploy[:user]
#    mode 0755
#  end

  deploy_wrapper "legacy_consumers" do
    owner deploy[:user]
    ssh_wrapper_dir "#{deploy[:home]}"
    ssh_key_dir "#{deploy[:home]}/.ssh"
    ssh_key_data deploy[:scm][:ssh_key]
    sloppy true
  end

#  timestamp = Time.now.strftime '%Y%m%d%H%M%S'
  deploy "legacy_consumers" do
    action :deploy
    repository deploy[:scm][:repository]
    branch  deploy[:scm][:revision]
    user deploy[:user]
    ssh_wrapper "#{deploy[:home]}/legacy_consumers_deploy_wrapper.sh"
    #ssh_wrapper "#{deploy[:home]}/chef_ssh_deploy_wrapper.sh"
    environment "RAILS_ENV" => 'staging'
  end
end
