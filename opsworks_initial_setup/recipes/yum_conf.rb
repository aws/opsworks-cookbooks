template '/etc/yum.conf' do
  source 'yum.conf.erb'
  mode 0444
  owner 'root'
  group 'root'
end

ruby_block "disable yum update-motd plugin" do
  block do
    rc = Chef::Util::FileEdit.new("/etc/yum/pluginconf.d/update-motd.conf")
    rc.search_file_replace_line(/^\s*enabled\s*=\s*1\s*$/, "enabled=0")
    rc.write_file
  end
  only_if do
    ::File.exists?("/etc/yum/pluginconf.d/update-motd.conf")
  end
end
