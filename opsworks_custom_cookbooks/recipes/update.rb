
# delete old
directory node[:opsworks_custom_cookbooks][:destination] do
  action :delete
  recursive true
end

# checkout new
include_recipe "opsworks_custom_cookbooks::checkout"
