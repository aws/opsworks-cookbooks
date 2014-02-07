include_recipe "deploy"

node[:deploy].each do |application, deploy|

  execute "touch /var/log/bluepill.log; chown #{deploy[:user]}:#{deploy[:group]} /var/log/bluepill.log"

end
