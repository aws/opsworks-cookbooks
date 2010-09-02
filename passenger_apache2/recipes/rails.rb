include_recipe "deploy::rails"
include_recipe "passenger_apache2::mod_rails"

# setup Apache virtual host
node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping passenger_apache2::rails application #{application} as it is not an Rails app")
    next
  end
  
  template "/etc/apache2/ssl/#{deploy[:domains].first}.crt" do
    mode '0600'
    source "ssl.key.erb"
    variables :key => deploy[:ssl_certificate]
    only_if do
      deploy[:ssl_support]
    end
  end
  
  template "/etc/apache2/ssl/#{deploy[:domains].first}.key" do
    mode '0600'
    source "ssl.key.erb"
    variables :key => deploy[:ssl_certificate_key]
    only_if do
      deploy[:ssl_support]
    end
  end
  
  template "/etc/apache2/ssl/#{deploy[:domains].first}.ca" do
    mode '0600'
    source "ssl.key.erb"
    variables :key => deploy[:ssl_certificate_ca]
    only_if do
      deploy[:ssl_support] && deploy[:ssl_certificate_ca]
    end
  end

  # move away default virtual host so that the Rails app becomes the default virtual host
  execute "mv away default virtual host" do
    action :run
    command "mv /etc/apache2/sites-enabled/000-default /etc/apache2/sites-enabled/zzz-default"
    only_if do 
      File.exists?("#{node[:apache][:dir]}/sites-enabled/000-default") 
    end
  end
end
