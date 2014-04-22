#
# Cookbook Name:: deploy
# Recipe:: insync
#

bash "insync backup" do
user 'root'
group 'root'
code <<-EOC
chmod 700 /opt/aws/opsworks/current/site-cookbooks/backup_script/backup.sh
/opt/aws/opsworks/current/site-cookbooks/backup_script/backup.sh
EOC
end