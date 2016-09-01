include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  template "/etc/yum.repos.d/public-yum-el5.repo" do
    source 'lumen/public-yum-el5.repo'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
  end

  yum_package 'libgcj'

  execute "download & install pdftk" do
    command "cd /tmp; wget https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-2.02-1.x86_64.rpm; rpm -ivh pdftk-2.02-1.x86_64.rpm"
  end



end