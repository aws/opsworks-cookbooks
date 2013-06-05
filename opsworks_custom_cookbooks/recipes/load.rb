if node[:opsworks_custom_cookbooks][:enabled]
  include_recipe "opsworks_custom_cookbooks::checkout"
else
  directory node[:opsworks_custom_cookbooks][:destination] do
    action :delete
    recursive true
  end
end

