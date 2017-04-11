require 'spec_helper'

describe 'opsworks_rabbitmq::cluster' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }

  let(:chef_run) do
    node.set['rabbitmq']['config'] = '/path/to/rabbitmq'

    node.set['opsworks']['layers']['rabbitmq']['instances'] = {
      :test1 => {},
      :test2 => {}
    }
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'builds cluster_disk_nodes attribute' do
    node = chef_run.node
    expect(node['rabbitmq']['cluster_disk_nodes']).to eq [
      "rabbit@test1",
      "rabbit@test2"
    ]
  end
end
