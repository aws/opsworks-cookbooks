include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  template "/etc/yum.repos.d/public-yum-el5.repo" do
    source 'lumen/public-yum-el5.repo'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
  end

end