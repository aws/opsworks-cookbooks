module OpsWorks
  module NodejsConfiguration
    def self.npm_install(app_name, app_config, app_root_path, npm_install_options)
      if File.exists?("#{app_root_path}/package.json")
        Chef::Log.info("package.json detected. Running npm #{npm_install_options}.")
        Chef::Log.info(OpsWorks::ShellOut.shellout("cd #{app_root_path} && sudo -Hu #{app_config[:user]} npm #{npm_install_options} 2>&1"))
      end
    end
  end
end
