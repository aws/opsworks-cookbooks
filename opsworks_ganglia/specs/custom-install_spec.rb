require 'minitest/spec'

describe_recipe 'opsworks_ganglia::custom-install' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates /usr/share/ganglia-webfrontend directory' do
    directory('/usr/share/ganglia-webfrontend').must_exist.with(:owner, 'root').and(:group, 'root')
  end

  it 'extracts web frontend tarball' do
    # Just check for the existence of a random file that's not already
    # created by the recipe, that should be proof enough
    file('/usr/share/ganglia-webfrontend/login.php').must_exist
  end

  it 'extracts reports tarball' do
    # Again, check for existence of random file in tarball
    file('/usr/share/ganglia-webfrontend/graph.d/apache_report.json').must_exist
  end

  it 'extracts templates tarball' do
    file('/usr/share/ganglia-webfrontend/templates/opsworks/show_node.tpl').must_exist
  end

  it 'creates make file' do
    file('/usr/share/ganglia-webfrontend/Makefile').must_exist.with(:mode, '644')
  end

  it 'ensures make install was run' do
    # Check if /var/lib/ganglia/dwoo exists. This should tell us if
    # make install actually executed.
    directory('/var/lib/ganglia/dwoo').must_exist
  end

  it 'creates events directory' do
    directory(node[:ganglia][:events_dir]).must_exist.with(:mode, '755').and(:owner, node[:ganglia][:web][:apache_user])
  end

  it 'creates conf.php' do
    file('/usr/share/ganglia-webfrontend/conf.php').must_exist.with(:mode, '644')
  end
end
