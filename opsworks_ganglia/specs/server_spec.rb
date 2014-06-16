require 'minitest/spec'

describe_recipe 'opsworks_ganglia::server' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs gmetad' do
    case node["platform_family"]
    when "debian"
      package('gmetad').must_be_installed
    when "rhel"
      package('ganglia-gmetad').must_be_installed
    end
  end

  it 'creates gmetad.conf' do
    file('/etc/ganglia/gmetad.conf').must_exist.with(:mode, '644')
  end

  it 'has stack name in gmetad.conf' do
    file('/etc/ganglia/gmetad.conf').must_include node[:opsworks][:stack][:name].gsub(/\W/,'-')
  end

  it 'starts and enables gmetad' do
    if node[:platform] == 'ubuntu' && node[:platform_version] == '14.04'
      service_resource = Chef::Resource::Service.new('gmetad', @run_context)
      service_resource.provider Chef::Provider::Service::Upstart
      service = service_resource.provider_for_action(:start).load_current_resource
      service.running.must_equal true
      service.enabled.must_equal true
    else
      service('gmetad').must_be_running
      service('gmetad').must_be_enabled
    end
  end
end
