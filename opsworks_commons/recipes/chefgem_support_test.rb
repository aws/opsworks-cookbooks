if node[:opsworks][:run_cookbook_tests]
  chef_gem "chefgem awesome_print install" do
    Chef::Log.info "[TEST] Installing rubygem awesome_print to test chef_gem resource"
    version '= 1.2.0'
    package_name "awesome_print"
    action :install
  end

  execute "chefgem awesome_print fail" do
    command "/bin/false"
    action :nothing
  end

  chef_gem "chefgem awesome_print install two" do
    Chef::Log.info "[TEST] Asked to install rubygem awesome_print 2nd time. Should not trigger install."
    version '= 1.2.0'
    package_name "awesome_print"
    action :install
    notifies :run, "execute[chefgem awesome_print fail]"
  end

  if require "awesome_print"
    Chef::Log.info "[TEST] Sucessfully loaded awesome_print installed with chef_gem"
    ap({:foo => "bar", "bazz" => [1,2,3]})
  else
   raise "Failed to load chef_gem installed rubygem."
  end

  chef_gem "chefgem awesome_print uninstall" do
    Chef::Log.info "[TEST] Deinstalling awesome_print rubygem to test chef_gem"
    version '1.2.0'
    package_name "awesome_print"
    action :remove
  end

  available = begin
                false
              rescue LoadError
                true
              end
  unless !available && $LOAD_PATH.grep(/awesome_print/).empty?
    raise "Failed to uninstall chef_gem: #{available} (LOAD_PATH: #{$LOAD_PATH.inspect})"
  else
    Chef::Log.info "[TEST] Sucessfully uninstalled awesome_print using chef_gem"
  end
end
