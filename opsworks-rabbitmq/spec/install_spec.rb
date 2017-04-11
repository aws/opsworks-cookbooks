require 'spec_helper'

describe 'opsworks_rabbitmq::install' do
  let(:runner) { ChefSpec::ServerRunner.new(UBUNTU_OPTS) }
  let(:node) { runner.node }

  let(:chef_run) do
    node.set['rabbitmq']['config'] = '/path/to/rabbitmq'
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'enables a rabbitmq service' do
    expect(chef_run).to enable_service('rabbitmq-server')
  end

  it 'start a rabbitmq service' do
    expect(chef_run).to start_service('rabbitmq-server')
  end

  it 'should have the use_distro_version set to false' do
    expect(chef_run.node['rabbitmq']['use_distro_version']).to eq(false)
  end

  # it 'should install the erlang package' do
  #   expect(chef_run).to install_package('erlang')
  # end

  context 'suse' do
    let(:runner) { ChefSpec::ServerRunner.new(SUSE_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    it 'should install the rabbitmq package' do
      expect(chef_run).to install_package('rabbitmq-server')
    end

    it 'should install the rabbitmq plugin package' do
      expect(chef_run).to install_package('rabbitmq-server-plugins')
    end
  end

  context 'debian-use_distro_version' do
    let(:runner) { ChefSpec::ServerRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      node.set['rabbitmq']['use_distro_version'] = true
      runner.converge(described_recipe)
    end

    it 'should install the logrotate package' do
      expect(chef_run).to install_package('logrotate')
    end

    it 'should install the rabbitmq distro package' do
      expect(chef_run).to install_package('rabbitmq-server')
    end
  end

  context 'debian' do
    let(:runner) { ChefSpec::ServerRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      node.set['rabbitmq']['version'] = '3.4.3'
      runner.converge(described_recipe)
    end

    it 'should install the logrotate package' do
      expect(chef_run).to install_package('logrotate')
    end

    it 'creates a rabbitmq-server deb in the cache path' do
      expect(chef_run).to create_remote_file_if_missing("#{Chef::Config[:file_cache_path]}/rabbitmq-server_#{node['rabbitmq']['version']}-1_all.deb")
    end

    it 'installs the rabbitmq-server deb_package with the default action' do
      expect(chef_run).to install_dpkg_package("#{Chef::Config[:file_cache_path]}/rabbitmq-server_#{node['rabbitmq']['version']}-1_all.deb")
    end
  end
end
