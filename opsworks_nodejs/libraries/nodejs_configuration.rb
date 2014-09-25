module OpsWorks
  module NodejsConfiguration
    def self.npm_install(_app_name, app_config, app_root_path)
      if File.exist?("#{app_root_path}/package.json")
        Chef::Log.info("package.json detected. Running npm install.")
        cmd = "sudo su #{app_config[:user]} -c 'cd #{app_root_path} && npm install'"
        Chef::Log.info(cmd)
        Chef::Log.info(`#{cmd}`)
      end
    end
  end
end
