require 'spec_helper'

describe service('Zabbix Agent') do
  it { should be_enabled }
  it { should be_running }
end
