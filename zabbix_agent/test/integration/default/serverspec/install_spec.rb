require 'spec_helper'

describe user('zabbix') do
  it { should exist }
  it { should belong_to_group 'zabbix' }
end

describe group('zabbix') do
  it { should exist }
end

describe file('/etc/zabbix/scripts') do
  it { should be_directory }
end

describe file('/etc/zabbix/zabbix_agentd.d') do
  it { should be_directory }
end

describe file('/var/log/zabbix') do
  it { should be_directory }
end
