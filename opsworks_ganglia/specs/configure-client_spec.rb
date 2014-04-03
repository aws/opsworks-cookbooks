require 'minitest/spec'

describe_recipe 'opsworks_ganglia::configure-client' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  before :all do 
    @monitoring_master = node[:opsworks][:layers].has_key?('monitoring-master')
    @monitoring_master_ip = node[:opsworks][:layers]['monitoring-master'][:instances].collect{|instance, names| names["private_ip"]}.first rescue nil
  end

  it 'creates gmond.conf' do
    if @monitoring_master
      file('/etc/ganglia/gmond.conf').must_exist
    else
      file('/etc/ganglia/gmond.conf').wont_exist
    end
  end

  it 'makes sure monitoring master is defined in gmond.conf' do
    skip unless @monitoring_master_ip
    file('/etc/ganglia/gmond.conf').must_include @monitoring_master_ip
  end

  it 'makes sure stack name is defined in gmond.conf' do
    skip unless @monitoring_master_ip
    file('/etc/ganglia/gmond.conf').must_include node[:opsworks][:stack][:name].gsub(/\W/,'-')
  end

  it 'makes sure gmond is running if necessary' do
    if @monitoring_master_ip
      service('gmond').must_be_running
    else
      service('gmond').wont_be_running
    end
  end
end
