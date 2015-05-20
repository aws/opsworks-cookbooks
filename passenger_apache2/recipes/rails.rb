unless node[:opsworks][:skip_uninstall_of_other_rails_stack]
  include_recipe "nginx::uninstall"
  include_recipe "unicorn::stop"
  include_recipe "puma::stop"
end

include_recipe "apache2"
include_recipe "apache2::mod_deflate"
include_recipe "passenger_apache2"
include_recipe "passenger_apache2::mod_rails"
