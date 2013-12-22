include_recipe 'apache2'

node[:mod_php5_apache2][:packages].each do |pkg|
  package pkg do
    action :install
    ignore_failure(pkg.to_s.match(/^php-pear-/) ? true : false) # some pear packages come from EPEL which is not always available
  end
end

include_recipe 'apache2::mod_php5'
