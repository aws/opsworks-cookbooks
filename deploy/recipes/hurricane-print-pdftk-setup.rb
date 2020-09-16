include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

  execute "download & install pdftk" do
    command "cd /tmp; curl https://www.linuxglobal.com/static/blog/pdftk-2.02-1.el7.x86_64.rpm -o pdftk-2.02-1.el7.x86_64.rpm;"
  end

	rpm_package 'pdftk-2.02-1.el7.x86_64.rpm' do
	  provider                   Chef::Provider::Package::Yum
	  source                     '/tmp/pdftk-2.02-1.el7.x86_64.rpm'
	  action                     :install
	end  



end