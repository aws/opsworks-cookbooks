execute "add user" do
  user "root"
  command '/opt/wildfly-' + node['wildfly']['version'] + '/bin/add-user.sh --silent ' + node['wildfly']['deploy_username'] + ' ' + node['wildfly']['deploy_password']
end