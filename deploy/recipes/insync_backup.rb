#
# Cookbook Name:: deploy
# Recipe:: insync
#

bash "move_backup.sh" do
user 'root'
group 'root'
code <<-EOC
cp /opt/aws/opsworks/current/site-cookbooks/backup_script/backup.sh /home/ubuntu
chmod 755 /home/ubuntu/backup.sh
EOC
end


bash "insync backup" do
user 'ubuntu'
group 'ubuntu'
code <<-EOC
/home/ubuntu/backup.sh
EOC
end
