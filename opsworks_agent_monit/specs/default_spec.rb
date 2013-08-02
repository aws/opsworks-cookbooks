require 'minitest/spec'

describe_recipe 'opsworks_agent_monit::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs monit' do
    package('monit').must_be_installed
  end

  it 'creates monit config directory' do
    directory(node[:monit][:conf_dir]).must_exist.with(:group, 'root').and(:owner, 'root')
  end

  it 'creates /etc/default/monit on debian based systems' do
    skip unless ['debian','ubuntu'].include?(node[:platform])
    file('/etc/default/monit').must_exist.with(:mode, '644')
  end

  it 'creates main monit conf file' do
    file(node[:monit][:conf]).must_exist.with(:mode, '600')
  end

  it 'ensures main monit conf file has the right config settings' do
    file(node[:monit][:conf]).must_include node[:monit][:conf_dir]
    file(node[:monit][:conf]).must_include 'set logfile syslog'
    file(node[:monit][:conf]).must_include 'set daemon 60'
  end

  it 'ensures opsworks-agent.monitrc is installed' do
    file(::File.join(node[:monit][:conf_dir], 'opsworks-agent.monitrc')).must_exist.with(:mode, '644')
  end

  it 'should create opsworks-agent.monitrc entries for each daemon log' do
    file(::File.join(node[:monit][:conf_dir], 'opsworks-agent.monitrc')).must_include "#{node[:opsworks_agent][:log_dir]}/opsworks-agent.statistic.log"
    file(::File.join(node[:monit][:conf_dir], 'opsworks-agent.monitrc')).must_include "#{node[:opsworks_agent][:log_dir]}/opsworks-agent.process-command.log"
    file(::File.join(node[:monit][:conf_dir], 'opsworks-agent.monitrc')).must_include "#{node[:opsworks_agent][:log_dir]}/opsworks-agent.keep-alive.log"
  end

  it 'should create opsworks-agent.monitrc with an entries for the pid file' do
    file(::File.join(node[:monit][:conf_dir], 'opsworks-agent.monitrc')).must_include "#{node[:opsworks_agent][:log_dir]}/pid/opsworks-agent.pid"
  end

  it 'ensures logging monitrc file is removed on rhel based systems' do
    file(::File.join(node[:monit][:conf_dir], 'logging')).wont_exist
  end

  it 'starts monit' do
    service('monit').must_be_running
  end

  it 'will not trigger the out-of-memory killer' do
    files = ["/var/log/messages", "/var/log/syslog"].select {|f| ::File.exists? f }
    files.length.must_be :>=, 1
    files.each {|f| file(f).wont_include "invoked oom-killer" }
  end
end
