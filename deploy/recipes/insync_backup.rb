#
# Cookbook Name:: deploy
# Recipe:: insync
#

bash "insync backup" do
user 'root'
group 'root'
code <<-EOC
/opt/aws/opsworks/current/site-cookbooks/backup_script/backup.sh
EOC
end