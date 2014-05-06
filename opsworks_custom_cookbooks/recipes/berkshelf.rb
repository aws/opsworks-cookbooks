if node[:opsworks_custom_cookbooks][:manage_berkshelf]
  include_recipe "opsworks_berkshelf::install"
else
  include_recipe "opsworks_berkshelf::purge"
end
