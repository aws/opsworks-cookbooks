require 'spec_helper'

describe 'rabbitmq::policy_management' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }
  let(:chef_run) do
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'includes the `default` recipe' do
    expect(chef_run).to include_recipe('rabbitmq::default')
  end

  it 'sets a rabbitmq policy ha-all' do
    expect(chef_run).to set_rabbitmq_policy('ha-all')
  end

  it 'sets a rabbitmq policy ha-two' do
    expect(chef_run).to set_rabbitmq_policy('ha-two')
  end
end
