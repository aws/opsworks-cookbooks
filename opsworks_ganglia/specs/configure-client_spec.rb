require 'minitest/spec'

describe_recipe 'opsworks_ganglia::configure-client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  before :all do 
    @monitoring_master = node[:opsworks][:layers]['monitoring-master'][:instances].collect{|instance, names| names["private_ip"]}.first rescue nil
  end

  it 'creates gmond.conf' do
    file('/etc/ganglia/gmond.conf').must_exist
  end

  it 'makes sure monitoring master is defined in gmond.conf' do
    skip unless @monitoring_master
    file('/etc/ganglia/gmond.conf').must_include @monitoring_master
  end

  it 'makes sure stack name is defined in gmond.conf' do
    file('/etc/ganglia/gmond.conf').must_include node[:opsworks][:stack][:name]
  end

  it 'makes sure gmond is running if necessary' do
    if @monitoring_master
      service('gmond').must_be_running
    else
      service('gmond').wont_be_running
    end
  end
end
