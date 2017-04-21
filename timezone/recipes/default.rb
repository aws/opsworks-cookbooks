node[:deploy].each do |application, deploy|

  execute "set_timezone" do
    Chef::Log.debug("timezone::default set_timezone")
    command 'sudo mv /etc/localtime /etc/localtime.bak; sudo ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime'
  end

end