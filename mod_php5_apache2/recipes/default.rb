include_recipe 'apache2'

node[:mod_php5_apache2][:packages].each do |pkg|
  package pkg do
    action :install
    ignore_failure(pkg.to_s.match(/^php-pear-/) ? true : false) # some pear packages come from EPEL which is not always available
  end
end

node[:deploy].each do |application, deploy|
  case node[:deploy][application][:database][:type]
  when "mysql"
    include_recipe 'mod_php5_apache2::mysql_adapter'
  when "postgresql"
    include_recipe 'mod_php5_apache2::postgresql_adapter'
  end
end

include_recipe 'apache2::mod_php5'
