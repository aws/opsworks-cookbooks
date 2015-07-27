def infrastructure_class?(other)
  node[:opsworks][:instance][:infrastructure_class] == other
end

def rhel6?
  %w(redhat centos).include?(node["platform"]) && Chef::VersionConstraint.new("~> 6.0").include?(node["platform_version"])
end

def rhel7?
  %w(redhat centos).include?(node["platform"]) && Chef::VersionConstraint.new("~> 7.0").include?(node["platform_version"])
end
