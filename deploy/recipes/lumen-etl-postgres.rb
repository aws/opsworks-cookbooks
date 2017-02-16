include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  unless File.exists?("/etc/yum.repos.d/pgdg-96-ami201503.repo")
    template "/etc/yum.repos.d/pgdg-96-ami201503.repo" do
      source 'lumen_etl/pgdg-96-ami201503.repo'
      mode '0660'
      owner deploy[:user]
      group deploy[:group]
    end

    yum_package 'postgresql96'
  end



end