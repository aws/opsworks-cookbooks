require 'minitest/spec'

describe_recipe 'opsworks_ganglia::configure-server' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates gmetad.conf' do
    file('/etc/ganglia/gmetad.conf').must_exist
  end

  it 'makes sure stack name is set in gmetad.conf' do
    file('/etc/ganglia/gmetad.conf').must_include node[:opsworks][:stack][:name]
  end

  it 'ensures gmetad is running' do
    service('gmetad').must_be_running
  end

  it 'creates conf.php for ganglia-webfrontend' do
    file('/usr/share/ganglia-webfrontend/conf.php').must_exist.with(:mode, '644')
  end

  it 'creates /etc/ganglia-webfrontend' do
    file('/etc/ganglia-webfrontend').must_exist.with(:mode, '755')
  end

  it 'updates htaccess' do
    file('/etc/ganglia-webfrontend/htaccess').must_exist
    file('/etc/ganglia-webfrontend/htaccess').must_include node[:ganglia][:web][:user]
  end

  it 'creates apache.conf' do
    file('/etc/ganglia-webfrontend/apache.conf').must_exist
  end

  it 'ensures apache.conf has web url' do
    file('/etc/ganglia-webfrontend/apache.conf').must_include node[:ganglia][:web][:url]
  end

  it 'links apache.conf to apache conf.d directory' do
    case node[:platform]
    when "debian","ubuntu"
      link(File.join(node[:apache][:dir], 'conf.d', 'ganglia-webfrontend')).must_exist.with(
           :link_type, :symbolic).and(:to, '/etc/ganglia-webfrontend/apache.conf')
    when "centos","redhat","amazon","fedora","scientific","oracle"
      link(File.join(node[:apache][:dir], 'conf.d', 'ganglia-webfrontend.conf')).must_exist.with(
           :link_type, :symbolic).and(:to, '/etc/ganglia-webfrontend/apache.conf')
    end
  end

  it 'creates index.html for apache doc root' do
    file(File.join(node[:apache][:document_root], 'index.html')).must_exist.with(:mode, '644')
  end

  it 'displays "Ganglia Monitoring" on the website' do
    assert system("curl http://localhost | grep 'Ganglia Monitoring'")
  end
end
