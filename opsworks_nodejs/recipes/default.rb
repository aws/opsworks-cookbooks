case node[:platform]
when 'debian', 'ubuntu'
  remote_file "/tmp/#{node[:opsworks_nodejs][:deb]}" do
    source node[:opsworks_nodejs][:deb_url]
    action :create_if_missing
  end

  execute "Install node.js #{node[:opsworks_nodejs][:version]}" do
    cwd "/tmp"
    command "dpkg -i /tmp/#{node[:opsworks_nodejs][:deb]}"

    not_if do
      ::File.exists?("/usr/local/bin/node") &&
      system("/usr/local/bin/node -v | grep -q '#{node[:opsworks_nodejs][:version]}'")
    end
  end

when 'centos','redhat','fedora','amazon'
  remote_file "/tmp/#{node[:opsworks_nodejs][:rpm]}" do
    source node[:opsworks_nodejs][:rpm_url]
    action :create_if_missing
  end

  rpm_package 'nodejs' do
    source "/tmp/#{node[:opsworks_nodejs][:rpm]}"
    not_if do
     ::File.exists?("/usr/local/bin/node") &&
     system("/usr/local/bin/node -v | grep -q '#{node[:opsworks_nodejs][:version]}'")
    end
  end
end
