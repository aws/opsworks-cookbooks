if node[:opsworks][:run_cookbook_tests]

  gem_package "awesome_print install" do
    Chef::Log.info "[TEST] Installing rubygem awesome_print to test gem resource"
    version '= 1.2.0'
    package_name "awesome_print"
    action :install
  end

end
