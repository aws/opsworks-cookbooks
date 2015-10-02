if node[:opsworks][:run_cookbook_tests]
  gem_package "gem_package awesome_print install" do
    Chef::Log.info "[TEST] Installing rubygem awesome_print to test gem resource"
    version '= 1.2.0'
    package_name "awesome_print"
    action :install
    retries 8
    retry_delay 15
  end

  execute "use gem_package awesome_print" do
    command "/usr/local/bin/ruby -e 'begin require \"ap\"; ap [1,2,3]; rescue Exception => e; puts \"\#{e.message} // \#{e.backtrace.inspect}\"; exit 1; end'"
  end

  gem_package "gem_package awesome_print install does not re-install" do
    version '= 1.2.0'
    package_name "awesome_print"
    action :install
    notifies :run, "execute[gem_package awesome_print fail]"
  end

  execute "gem_package awesome_print fail" do
    command "/bin/false"
    action :nothing
  end

  gem_package "gem_package awesome_print uninstall" do
    Chef::Log.info "[TEST] Installing rubygem awesome_print to test gem resource"
    version '1.2.0'
    package_name "awesome_print"
    action :remove
  end

  execute "ensure gem_package awesome_print is gone" do
    command "/usr/local/bin/ruby -e 'begin require \"ap\"; exit! 1; rescue Exception; end'"
  end
end
