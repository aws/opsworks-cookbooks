def infrastructure_class?(other)
  node[:opsworks][:instance][:infrastructure_class] == other
end
