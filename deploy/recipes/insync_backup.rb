#
# Cookbook Name:: deploy
# Recipe:: insync
#

bash "insync backup" do
user 'ubuntu'
group 'ubuntu'
code <<-EOC
/opt/aws/opsworks/current/site-cookbooks/backup_script/backup.sh
EOC
end