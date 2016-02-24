if node[:opsworks_postgresql] && ([:devel_package, :client_package].all? {|s| node[:opsworks_postgresql].key? s})
  # Only use the default package names if attributes exist and they are
  # defined so we don't break anyone who has overriden this recipe
  [node[:opsworks_postgresql][:devel_package], node[:opsworks_postgresql][:client_package]].each do |pkg|
    package pkg do
      action :install
      retries 3
      retry_delay 5
    end
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
