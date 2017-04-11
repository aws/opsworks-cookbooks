require 'spec_helper'

describe 'opsworks_rabbitmq::configure' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }

  let(:chef_run) do
    node.set['rabbitmq']['config'] = '/path/to/rabbitmq'
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'creates a directory for mnesiadir' do
    expect(chef_run).to create_directory('/var/lib/rabbitmq/mnesia')
  end

  it 'creates a template rabbitmq-env.conf with attributes' do
    expect(chef_run).to create_template('/etc/rabbitmq/rabbitmq-env.conf').with(
    :user => 'root',
    :group => 'root',
    :source => 'rabbitmq-env.conf.erb',
    :mode => 00644)
  end

  it 'should create the directory /var/lib/rabbitmq/mnesia' do
    expect(chef_run).to create_directory('/var/lib/rabbitmq/mnesia').with(
    :user => 'rabbitmq',
    :group => 'rabbitmq',
    :mode => '775'
    )
  end

  it 'should have the use_distro_version set to false' do
    expect(chef_run.node['rabbitmq']['use_distro_version']).to eq(false)
  end

  it 'creates a template rabbitmq.config with attributes' do
    expect(chef_run).to create_template('/path/to/rabbitmq.config').with(
    :user => 'root',
    :group => 'root',
    :source => 'rabbitmq.config.erb',
    :mode => 00644)
  end
end
