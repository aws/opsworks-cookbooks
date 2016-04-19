require 'chefspec'
require 'chefspec/berkshelf'


describe 'logentries_agent::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs logentries' do
    stub_command('test -e /etc/init.d/logentries').and_return(0)
    stub_command('le whoami').and_return('name = spectest')
    stub_command("le followed '/var/log/syslog'").and_return('Following /var/log/syslog')
    stub_command("le followed '/var/log/*.log'").and_return('Following /var/log/*.log')
    expect(chef_run).to install_package(%w(logentries logentries-daemon))
  end
end
