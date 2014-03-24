if node[:opsworks][:layers]['db-master']
  include_recipe 'mysql::client_install'
else
  Chef::Log.info 'No db-master node found. Skipping MySQL client package installation.'
end
