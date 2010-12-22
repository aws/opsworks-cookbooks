
package "xfsprogs"
package "xfsdump"
package "xfslibs-dev"

include_recipe "ebs::volumes"
unless node[:ebs][:raids].blank?
  include_recipe "ebs::raids"
end 