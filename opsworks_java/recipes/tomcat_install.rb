tomcat_pkgs = case node["platform_family"]
              when "debian" then ["tomcat#{node["opsworks_java"]["tomcat"]["base_version"]}", "libtcnative-1"]
              when "rhel" then
                if rhel7?
                  ["tomcat", "tomcat-native"]
                else
                  ["tomcat#{node["opsworks_java"]["tomcat"]["base_version"]}", "tomcat-native"]
                end
              end

tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

# remove the ROOT webapp, if it got installed by default
include_recipe 'opsworks_java::remove_root_webapp'
