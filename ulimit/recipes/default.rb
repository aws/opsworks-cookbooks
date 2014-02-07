# Cookbook Name:: ulimit
# Recipe:: default
#
# Copyright 2012, Brightcove, Inc
#
# All rights reserved - Do Not Redistribute
#
ulimit = node['ulimit']

case node[:platform]
  when "debian", "ubuntu"
    template "/etc/pam.d/su" do
      cookbook ulimit['pam_su_template_cookbook'] 
    end
end
