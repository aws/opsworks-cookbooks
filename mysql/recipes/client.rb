if node[:mysql][:use_percona_xtradb]
  include_recipe "mysql::percona_client"
else
  package "mysql-devel" do
    package_name value_for_platform(
      [ "centos", "redhat", "suse" ] => { "default" => "mysql-devel" },
      "ubuntu" => {'default' => 'libmysqlclient-dev'}
    )
    action :install
  end

  package "mysql-client" do
    package_name value_for_platform(
      [ "centos", "redhat", "suse" ] => { "default" => "mysql" },
      "default" => "mysql-client"
    )
    action :install
  end
end
