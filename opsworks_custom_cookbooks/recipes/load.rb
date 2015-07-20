if node[:opsworks_custom_cookbooks][:enabled]
  include_recipe "opsworks_custom_cookbooks::checkout"
  ruby_block 'merge all cookbooks sources' do
    block do
       FileUtils.rm_rf Opsworks::InstanceAgent::Environment.merged_cookbooks_path
       FileUtils.cp_r Opsworks::InstanceAgent::Environment.default_cookbooks_path, Opsworks::InstanceAgent::Environment.merged_cookbooks_path
       FileUtils.cp_r "#{Opsworks::InstanceAgent::Environment.berkshelf_cookbooks_path}/.", Opsworks::InstanceAgent::Environment.merged_cookbooks_path if ::File.directory?(Opsworks::InstanceAgent::Environment.  berkshelf_cookbooks_path)
       FileUtils.cp_r "#{Opsworks::InstanceAgent::Environment.site_cookbooks_path}/.", Opsworks::InstanceAgent::Environment.merged_cookbooks_path if ::File.directory?(Opsworks::InstanceAgent::Environment.  site_cookbooks_path)
    end
  end
else
  directory node[:opsworks_custom_cookbooks][:destination] do
    action :delete
    recursive true

    only_if {node[:opsworks_custom_cookbooks][:destination]}
  end
  template '/var/lib/aws/opsworks/client.stage2.rb' do
    source 'client.stage.erb'
    owner 'aws'
    group 'aws'
    mode '0644'
  end
end

