require 'spec_helper'

describe 'rabbitmq::community_plugins' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }
  let(:chef_run) do
    node.set['rabbitmq']['community_plugins'] = { 'rabbitmq_community_plugin' => 'http://sample.com/rabbitmq_community_plugin.ez' }
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'includes the `default` recipe' do
    expect(chef_run).to include_recipe('rabbitmq::default')
  end

  plugins = { 'rabbitmq_community_plugin' => 'http://sample.com/rabbitmq_community_plugin.ez' }

  plugins.each do |plugin, download_url|
    it 'creates the remote files with attributes' do
      expect(chef_run).to create_remote_file("/usr/lib/rabbitmq/lib/rabbitmq_server-#{node['rabbitmq']['version']}/plugins/#{plugin}.ez").with(
        :mode => '0644',
        :owner => 'root',
        :group => 'root',
        :source => download_url
      )
    end

    it 'enables community plugins' do
      expect(chef_run).to enable_rabbitmq_plugin(plugin)
    end
  end
end
