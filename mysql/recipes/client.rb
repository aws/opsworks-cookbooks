if node[:mysql][:use_percona_xtradb]
  include_recipe "mysql::percona_client"
else
  package "mysql-devel" do
    package_name value_for_platform(
      [ "centos", "redhat", "suse" ] => { "default" => "mysql-devel" },
      "ubuntu" => {'9.10' => 'libmysqlclient15-dev', '10.04' => 'libmysqlclient16-dev', '11.04' => 'libmysqlclient16-dev', '11.10' => 'libmysqlclient16-dev'}
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
