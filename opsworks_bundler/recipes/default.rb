if node[:opsworks_bundler][:manage_package]
  gem_package "Installing Bundler #{node[:opsworks_bundler][:version]}" do
    gem_binary node[:dependencies][:gem_binary]
    retries 2
    package_name "bundler"
    action :install
    version node[:opsworks_bundler][:version]
  end

  # alternative/fallback install of bundler for more robustness
  # handle cases where the gem library is there but the executable is missing
  ruby_block "Fallback Bundler install of #{node[:opsworks_bundler][:version]}" do
    block do
      system("gem install bundler -v=#{node[:opsworks_bundler][:version]} --no-ri --no-rdoc")
    end
    only_if do
      !system("gem list bundler -v=#{node[:opsworks_bundler][:version]} --installed") || !File.exists?(node[:opsworks_bundler][:executable])
    end
  end
end
