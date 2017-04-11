require 'spec_helper'

describe 'yum::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates yum_globalconfig[/etc/yum.conf]' do
    expect(chef_run).to create_yum_globalconfig('/etc/yum.conf')
  end

end
