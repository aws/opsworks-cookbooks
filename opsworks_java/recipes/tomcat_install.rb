tomcat_pkgs = value_for_platform_family(
  'debian' => ["tomcat#{node['opsworks_java']['tomcat']['base_version']}", 'libtcnative-1'],
  'rhel' => ["tomcat#{node['opsworks_java']['tomcat']['base_version']}", 'tomcat-native']
)

tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

# remove the ROOT webapp, if it got installed by default
include_recipe 'opsworks_java::remove_root_webapp'
