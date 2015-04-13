cron "s3sync" do
  action node.tags.include?('s3sync') ? :create : :delete
  minute '*/05'
  hour '*'
  weekday '*'
  user "deploy"
  mailto "asilva@estantevirtual.com.br"
  home "/home/deploy"
  command "s3cmd -c /etc/s3sync/s3cfg --no-delete-removed sync #{node[:s3sync][:ftp_path]} #{node[:s3sync][:bucket]}"
end
