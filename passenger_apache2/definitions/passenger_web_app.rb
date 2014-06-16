define :passenger_web_app do
  include_recipe "apache2::service"
  deploy = params[:deploy]
  application = params[:application]

  template "#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.crt" do
    cookbook 'passenger_apache2'
    mode '0600'
    source "ssl.key.erb"
    variables :key => deploy[:ssl_certificate]
    notifies :restart, "service[apache2]"
    only_if do
      deploy[:ssl_support]
    end
  end

  template "#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.key" do
    cookbook 'passenger_apache2'
    mode '0600'
    source "ssl.key.erb"
    variables :key => deploy[:ssl_certificate_key]
    notifies :restart, "service[apache2]"
    only_if do
      deploy[:ssl_support]
    end
  end

  template "#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.ca" do
    cookbook 'passenger_apache2'
    mode '0600'
    source "ssl.key.erb"
    variables :key => deploy[:ssl_certificate_ca]
    notifies :restart, "service[apache2]"
    only_if do
      deploy[:ssl_support] && deploy[:ssl_certificate_ca]
    end
  end

  # move away default virtual host so that the Rails app becomes the default virtual host
  if platform?('ubuntu') && node[:platform_version] == '14.04'
    source_default_site_config = "#{node[:apache][:dir]}/sites-enabled/000-default.conf"
    target_default_site_config = "#{node[:apache][:dir]}/sites-enabled/zzz-default.conf"
  else
    source_default_site_config = "#{node[:apache][:dir]}/sites-enabled/000-default"
    target_default_site_config = "#{node[:apache][:dir]}/sites-enabled/zzz-default"
  end
  execute "mv away default virtual host" do
    action :run
    command "mv #{source_default_site_config} #{target_default_site_config}"
    only_if do
      File.exists?(source_default_site_config)
    end
  end

  web_app deploy[:application] do
    docroot deploy[:absolute_document_root]
    server_name deploy[:domains].first
    server_aliases deploy[:domains][1, deploy[:domains].size] unless deploy[:domains][1, deploy[:domains].size].empty?
    rails_env deploy[:rails_env]
    mounted_at deploy[:mounted_at]
    ssl_certificate_ca deploy[:ssl_certificate_ca]
    cookbook "passenger_apache2"
    deploy deploy
  end
end
