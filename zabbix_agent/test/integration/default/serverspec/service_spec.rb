require 'spec_helper'

describe service('zabbix_agentd') do
  it { should be_running }
end
