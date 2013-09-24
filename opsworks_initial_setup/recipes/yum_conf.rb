ruby_block "enable keepcache in yum.conf" do
  block do
    rc = Chef::Util::FileEdit.new("/etc/yum.conf")
    rc.search_file_delete_line(/^\s*keepcache\s*=/)
    rc.insert_line_after_match(/^\[main\]$/, "keepcache=1")
    rc.write_file
  end
  only_if do
    ::File.exists?("/etc/yum.conf")
  end
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
