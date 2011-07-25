include_recipe "apache::service"
package "apache2" do
  action :remove
end