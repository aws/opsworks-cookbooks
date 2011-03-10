
# delete old
directory node[:scalarium_custom_cookbooks][:destination] do
  action :delete
  recursive true
end

# checkout new
include_recipe "scalarium_custom_cookbooks::checkout"