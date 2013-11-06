ruby_block 'remove the ROOT webapp' do
  block do
    ::FileUtils.rm_rf(::File.join(node['opsworks_java'][node['opsworks_java']['java_app_server']]['webapps_base_dir'], 'ROOT'), :secure => true)
  end
  only_if { ::File.exists?(::File.join(node['opsworks_java'][node['opsworks_java']['java_app_server']]['webapps_base_dir'], 'ROOT')) && !::File.symlink?(::File.join(node['opsworks_java'][node['opsworks_java']['java_app_server']]['webapps_base_dir'], 'ROOT')) }
end
