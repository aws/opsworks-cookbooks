require 'spec_helper'

describe 'opsworks_rabbitmq::user_management' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }
  let(:chef_run) do
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'includes the `virtualhost_management` recipe' do
    expect(chef_run).to include_recipe('opsworks_rabbitmq::virtualhost_management')
  end
end
