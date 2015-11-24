require 'spec_helper'

describe file('/etc/zabbix/zabbix_agentd.conf') do
  it { should be_file }
end
