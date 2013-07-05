# setup Apache virtual host
node[:deploy].each do |application, deploy|
  include_recipe 'apache2::service'

  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping mod_php5_apache2::php application #{application} as it is not an PHP app")
    next
  end

  web_app deploy[:application] do
    docroot deploy[:absolute_document_root]
    server_name deploy[:domains].first
    unless deploy[:domains][1, deploy[:domains].size].empty?
      server_aliases deploy[:domains][1, deploy[:domains].size]
    end
    mounted_at deploy[:mounted_at]
    ssl_certificate_ca deploy[:ssl_certificate_ca]
  end

  template "#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.crt" do
    mode 0600
    source 'ssl.key.erb'
    variables :key => deploy[:ssl_certificate]
    notifies :restart, "service[apache2]"
    only_if do
      deploy[:ssl_support]
    end
  end

  template "#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.key" do
    mode 0600
    source 'ssl.key.erb'
    variables :key => deploy[:ssl_certificate_key]
    notifies :restart, "service[apache2]"
    only_if do
      deploy[:ssl_support]
    end
  end

  template "#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.ca" do
    mode 0600
    source 'ssl.key.erb'
    variables :key => deploy[:ssl_certificate_ca]
    notifies :restart, "service[apache2]"
    only_if do
      deploy[:ssl_support] && deploy[:ssl_certificate_ca]
    end
  end

  # move away default virtual host so that the new app becomes the default virtual host
  execute 'mv away default virtual host' do
    action :run
    command "mv #{node[:apache][:dir]}/sites-enabled/000-default \
                #{node[:apache][:dir]}/sites-enabled/zzz-default"
    notifies :reload, "service[apache2]", :delayed
    only_if do
      ::File.exists?("#{node[:apache][:dir]}/sites-enabled/000-default")
    end
  end
end
