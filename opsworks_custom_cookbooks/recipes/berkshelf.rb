include_recipe "opsworks_berkshelf::install" if node[:opsworks_custom_cookbooks][:manage_berkshelf]
