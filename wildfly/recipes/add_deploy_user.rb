execute "add user" do
  user "root"
  command 'sudo /opt/wildfly-' + node['wildfly']['version'] + '/bin/add-user.sh ' + node['wildfly']['deploy_username'] + ' ' + node['wildfly']['deploy_password']
end