local_nodejs_up_to_date = ::File.exists?("/usr/local/bin/node") && system("/usr/local/bin/node -v | grep -q '#{node[:opsworks_nodejs][:version]}'")

case node[:platform]
when 'debian', 'ubuntu'
  remote_file "/tmp/#{node[:opsworks_nodejs][:deb]}" do
    source node[:opsworks_nodejs][:deb_url]
    action :create_if_missing
    not_if do
      local_nodejs_up_to_date
    end
  end

  execute "Remove old node.js versions due to update" do
    command "dpkg --purge nodejs"
    only_if do
      ::File.exists?("/tmp/#{node[:opsworks_nodejs][:deb]}")
    end
  end

  execute "Install node.js #{node[:opsworks_nodejs][:version]}" do
    cwd "/tmp"
    command "dpkg -i /tmp/#{node[:opsworks_nodejs][:deb]}"
    only_if do
      ::File.exists?("/tmp/#{node[:opsworks_nodejs][:deb]}")
    end
  end

when 'centos','redhat','fedora','amazon'
  remote_file "/tmp/#{node[:opsworks_nodejs][:rpm]}" do
    source node[:opsworks_nodejs][:rpm_url]
    action :create_if_missing
    not_if do
      local_nodejs_up_to_date
    end
  end

  rpm_package "Install node.js #{node[:opsworks_nodejs][:version]}" do
    source "/tmp/#{node[:opsworks_nodejs][:rpm]}"
    action :install
    options "--verbose --oldpackage"
    only_if do
     ::File.exists?("/tmp/#{node[:opsworks_nodejs][:rpm]}")
    end
  end

end

execute "Clean up nodejs files" do
  cwd "/tmp"
  command "rm -f #{node[:opsworks_nodejs][:rpm]} #{node[:opsworks_nodejs][:deb]}"
end
