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

  it 'creates /etc/ganglia-webfrontend' do
    file('/etc/ganglia-webfrontend').must_exist.with(:mode, '755')
  end

  it 'updates htaccess' do
    file('/etc/ganglia-webfrontend/htaccess').must_exist
    file('/etc/ganglia-webfrontend/htaccess').must_include node[:ganglia][:web][:user]
  end

  it 'removes the default ganglia apache configuration' do
    file(::File.join(node['apache']['dir'], "conf.d", "ganglia.conf")).wont_exist
  end

  it 'creates apache configuration' do
    case node["platform_family"]
    when "debian"
      link(
        ::File.join(node['apache']['dir'], "sites-enabled", "opsworks-ganglia.conf")
      ).must_exist.with(:link_type, :symbolic).and(
        :to, ::File.join('..', "sites-available", "opsworks-ganglia.conf")
      )
    when "rhel"
      file(::File.join(node['apache']['dir'], "conf.d", "opsworks-ganglia.conf")).must_exist
    end
  end

  it 'creates the ganglia entry page for apache doc root' do
    file(File.join(node[:apache][:document_root], node[:ganglia][:web][:welcome_page])).must_exist.with(
      :mode, '644').and(:owner, node[:apache][:user]).and(:group, node[:apache][:group])
  end

  it 'ensures apache2/httpd is running' do
    case node["platform_family"]
    when "debian"
     service('apache2').must_be_running
    when "rhel"
      service('httpd').must_be_running
    end
  end

  it 'displays "Ganglia Monitoring" on the website' do
    assert system("curl http://localhost | grep 'Ganglia Monitoring'")
  end
end
