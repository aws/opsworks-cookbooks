include_recipe 'apache2'

node[:mod_php5_apache2][:packages].each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe 'apache2::mod_php5'
