#include_recipe 'dependencies'

#node[:deploy].each do |application, deploy|

 # opsworks_deploy_user do
  #  deploy_data deploy
  #end

#end

#
# Cookbook Name:: conduit-new-endpoint
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Dresources(:service => "jetty")o Not Redistribute
#

include_recipe "jetty"


bash "remove root" do
   user "root"
   code "rm -rf \"/usr/share/jetty/webapps/root\""
   not_if {!File.exists?("/usr/share/jetty/webapps/root")}
end

remote_file "/usr/share/jetty/webapps/root.war" do

        notifies :stop , resources(:service => "jetty")
	source "https://s3.amazonaws.com/conduit-data/jars/swamp.war"
	mode 0644
	owner "root"
        notifies :start, resources(:service => "jetty")
	#checksum "88b3b68f581d9c53c6ade52f70207114cceac368ff2200ac036a73d3efa0ef7f"
end
