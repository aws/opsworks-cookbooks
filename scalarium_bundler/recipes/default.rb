if node[:scalarium_bundler][:manage_package]
  gem_package "Installing Bundler #{node[:scalarium_bundler][:version]}" do
    gem_binary node[:dependencies][:gem_binary]
    retries 2
    package_name "bundler"
    action :install
    version node[:scalarium_bundler][:version]
  end
end
