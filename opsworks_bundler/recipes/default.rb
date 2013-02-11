if node[:opsworks_bundler][:manage_package]
  gem_package "Installing Bundler #{node[:opsworks_bundler][:version]}" do
    gem_binary node[:dependencies][:gem_binary]
    retries 2
    package_name "bundler"
    action :install
    version node[:opsworks_bundler][:version]
  end
end
