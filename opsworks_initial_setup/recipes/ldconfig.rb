template '/etc/ld.so.conf.d/opsworks-user-space.conf' do
  source 'ldconfig-opsworks-user-space.conf.erb'
  mode 0444
  owner 'root'
  group 'root'
end

execute 'Configure dynamic linker run-time bindings' do
 command 'ldconfig'
end
