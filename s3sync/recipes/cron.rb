cron "s3sync" do
  action :create
  minute '*/05'
  hour '*'
  weekday '*'
  user "deploy"
  mailto "asilva@estantevirtual.com.br"
  home "/home/deploy"
  command "s3cmd -p -c /etc/s3sync/s3cfg --no-delete-removed sync #{node[:s3sync][:ftp_path]} s3://#{node[:s3sync][:bucket]}"
end
