require 'tmpdir'

ruby_block 'Remove temp directories' do
  block do
    Dir.glob(Dir.tmpdir + '/opsworks*').each do |tmpdir|
      system("rm -rf #{tmpdir}")
    end
  end
end

ruby_block "Clean up old chef log files" do
  block do
    logs = Dir.glob("#{node[:opsworks_cleanup][:log_dir]}/*.log").sort
    if logs.size > node[:opsworks_cleanup][:keep_logs].to_i
      Chef::Log.info("Clean up: There are #{logs.size} logs - keeping only #{node[:opsworks_cleanup][:keep_logs]}")
      logs_to_delete = logs[0, (logs.size - node[:opsworks_cleanup][:keep_logs].to_i - 1)]
      logs_to_delete.each do |log|
        system("rm #{log}")
        system("rm #{log.gsub(/\.log$/, '.json')}")
      end
    else
      Chef::Log.info("Clean up: There are fewer than #{node[:opsworks_cleanup][:keep_logs]} logs - skipping cleanup")
    end
  end

  only_if do
    File.exists?(node[:opsworks_cleanup][:log_dir])
  end
end
