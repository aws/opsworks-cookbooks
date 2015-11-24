require 'spec_helper'

describe file('C:\programdata\zabbix\zabbix_agentd.conf') do
  it { should be_file }
end
