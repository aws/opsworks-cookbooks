if node[:opsworks_postgresql] && ([:devel_package, :client_package].all? {|s| node[:opsworks_postgresql].key? s})
  if node[:opsworks_postgresql][:yum_repo_template]
    repo_file_path = File.join('/etc/yum.repos.d', node[:opsworks_postgresql][:yum_repo_template])
    unless File.exists?(repo_file_path)
      template repo_file_path do
        source node[:opsworks_postgresql][:yum_repo_template]
        mode '0644'
        owner deploy[:user]
        group deploy[:group]
      end
    end
  end
  [node[:opsworks_postgresql][:devel_package], node[:opsworks_postgresql][:client_package]].each do |pkg|
    package pkg do
      action :install
      retries 3
      retry_delay 5
    end
  end
  pg_config = %x( which pg_config ).gsub(/\n/,'')
  link '/usr/bin/pg_config' do
    to pg_config
  end
else
  # old behavior for backwards compatibility
  package "postgresql-devel" do
    package_name value_for_platform(
      ["centos","redhat","fedora","amazon"] => {"default" => "postgresql-devel"},
      "ubuntu" => {"default" => "libpq-dev"}
    )
    action :install
    retries 3
    retry_delay 5
  end

  package "postgresql-client" do
    package_name value_for_platform(
      ["centos","redhat","fedora","amazon"] => {"default" => "postgresql"},
      "default" => "postgresql-client"
    )
    action :install
    retries 3
    retry_delay 5
  end
end
