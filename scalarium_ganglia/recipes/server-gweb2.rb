execute "Get newest version of ganglia web interface from github" do
  command "cd /tmp && git clone git://github.com/vvuksan/ganglia-misc.git"
end

template "/tmp/ganglia-misc/ganglia-web/Makefile" do
  source "Makefile.erb"
  mode '0644'
end

execute "Execute make install" do
  command "make install"
end

