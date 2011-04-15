#
# Cookbook Name:: apache2
# Definition:: web_app
#
# Copyright 2008, OpsCode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

define :web_app, :template => "web_app.conf.erb" do
  
  application_name = params[:name]

  include_recipe "apache2"
  include_recipe "apache2::mod_rewrite"
  include_recipe "apache2::mod_deflate"
  include_recipe "apache2::mod_headers"
  
  ruby_block 'Detect includes for vhost' do
    inner_params = params
    inner_application_name = application_name
    inner_node = node

    block do
      if File.exists?(local_config = "#{inner_node[:apache][:dir]}/sites-available/#{inner_application_name}.conf.d/local")
        Chef::Log.info("local config for #{inner_application_name} detected")
        inner_params[:local_config] = local_config
      end

      if File.exists?(rewrite_config = "#{inner_node[:apache][:dir]}/sites-available/#{inner_application_name}.conf.d/rewrite")
        Chef::Log.info("rewrite config for #{inner_application_name} detected")
        inner_params[:rewrite_config] = rewrite_config
      end
    end
  end

  template "#{node[:apache][:dir]}/sites-available/#{application_name}.conf" do
    Chef::Log.debug("Generating Apache site template for #{application_name.inspect}")
    source params[:template]
    owner "root"
    group "root"
    mode 0644
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
      :application_name => application_name,
      :params => params
    )
    if File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application_name}.conf")
      notifies :reload, resources(:service => "apache2"), :delayed
    end
  end
  
  apache_site "#{params[:name]}.conf" do
    enable enable_setting
  end
end
