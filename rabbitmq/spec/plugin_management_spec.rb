require 'spec_helper'

describe 'rabbitmq::plugin_management' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }
  let(:chef_run) do
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'includes the `default` recipe' do
    expect(chef_run).to include_recipe('rabbitmq::default')
  end
end
