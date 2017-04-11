root_path = "#{node['solr']['dir']}-#{node['solr']['version']}"

directory "#{root_path}/newrelic/" do
  owner node['solr']['user']
  group node['solr']['group']
  recursive true
  action :create
end

cookbook_file "#{root_path}/newrelic/newrelic.jar" do
  source "newrelic.jar"
  action :create_if_missing
end

template "#{root_path}/newrelic/newrelic.yml" do
  source "newrelic.yml.erb"
  variables(app_name: "#{node['opsworks']['stack']['name']} - Solr")
end
