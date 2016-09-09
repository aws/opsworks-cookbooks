include_recipe 'deploy'
Chef::Log.level = :debug

node[:deploy].each do |application, deploy|

#sudo yum install fontconfig freetype freetype-devel fontconfig-devel libstdc++
#wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2
#sudo mkdir -p /opt/phantomjs
#bzip2 -d phantomjs-1.9.8-linux-x86_64.tar.bz2
#sudo tar -xvf phantomjs-1.9.8-linux-x86_64.tar --directory /opt/phantomjs/ --strip-components 1
#sudo ln -s /opt/phantomjs/bin/phantomjs /usr/bin/phantomjs

  yum_package 'fontconfig'
  yum_package 'freetype'
  yum_package 'freetype-devel'
  yum_package 'fontconfig-devel'
  yum_package 'libstdc++'

  execute "download phantomjs" do
    command "cd /tmp; wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2;"
  end

  execute "create dir phantomjs" do
    command "sudo mkdir -p /opt/phantomjs"
  end

  execute "unzip and install phantomjs" do
    command "cd /tmp; bzip2 -d phantomjs-2.1.1-linux-x86_64.tar.bz2; sudo tar -xvf phantomjs-2.1.1-linux-x86_64.tar --directory /opt/phantomjs/ --strip-components 1"
  end

  execute "create link" do
    command 'sudo ln -s /opt/phantomjs/bin/phantomjs /usr/bin/phantomjs'
  end

end