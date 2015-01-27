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

define :web_app, :template => 'web_app.conf.erb' do
  
  application_name = params[:name]

  include_recipe 'apache2'
  include_recipe 'apache2::mod_rewrite'
  include_recipe 'apache2::mod_deflate'
  include_recipe 'apache2::mod_headers'
  
  directory "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d"
  params[:rewrite_config] = "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d/rewrite"
  params[:local_config] = "#{node[:apache][:dir]}/sites-available/#{application_name}.conf.d/local"

  template "#{node[:apache][:dir]}/sites-available/#{application_name}.conf" do
    Chef::Log.debug("Generating Apache site template for #{application_name.inspect}")
    source params[:template]
    owner 'root'
    group 'root'
    mode 0644
    if params[:cookbook]
      cookbook params[:cookbook]
    end

    deploy = node[:deploy][application_name]
    environment_variables = {}    

    if !deploy.nil? && !deploy[:environment_variables].nil?       
        environment_variables = deploy[:environment_variables] if !deploy[:environment_variables].empty?
    end

    variables(
      :application_name => application_name,
      :params => params,
      :environment => OpsWorks::Escape.escape_double_quotes(environment_variables)
    )
    if ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application_name}.conf")
      notifies :reload, "service[apache2]", :delayed
    end
  end
  
  apache_site "#{params[:name]}.conf" do
    enable enable_setting
  end
end
