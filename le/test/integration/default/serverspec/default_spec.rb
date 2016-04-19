require 'spec_helper'

describe 'logentries_agent::default' do

  it 'installs package' do
    expect(package('logentries-daemon')).to be_installed
  end

  context 'creates config' do
    describe file('/etc/le/config') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_mode 640 }
      its(:content) { should match /path=\/var\/log\/syslog/ }
      its(:content) { should match /path=\/var\/log\/\*\.log/ }
    end
  end

  it 'runs service' do
    expect(service('logentries')).to be_running
  end

  it 'enables service' do
    expect(service('logentries')).to be_enabled
  end
end
