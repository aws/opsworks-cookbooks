if node[:opsworks][:run_cookbook_tests]

  chef_gem "awesome_print" do
    Chef::Log.info "[TEST] Installing rubygem awesome_print to test chef_gem resource"
    version '~> 1.0.0'
    action :install
  end

  if require "awesome_print"
   Chef::Log.debug "[TEST] Sucessfully loaded awesome_print installed with chef_gem"
  else
   raise "Failed to load chef_gem installed rubygem."
  end

  chef_gem "awesome_print" do
    Chef::Log.info "[TEST] Deinstalling awesome_print rubygem to test chef_gem"
    version '>= 2.0.0'
    action :remove
  end

  if require "awesome_print" || $LOAD_PATH.grep(/awesome_print/)
   raise "Failed to uninstall chef_gem."
  else
   Chef::Log.debug "[TEST] Sucessfully uninstalled awesome_print using chef_gem"
  end

end
