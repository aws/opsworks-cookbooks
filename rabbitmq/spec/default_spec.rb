require 'spec_helper'

describe 'rabbitmq::default' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }

  let(:chef_run) do
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  include_context 'rabbitmq-stubs'

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

  it 'enables a rabbitmq service' do
    expect(chef_run).to enable_service('rabbitmq-server')
  end

  it 'start a rabbitmq service' do
    expect(chef_run).to start_service('rabbitmq-server')
  end

  it 'should have the use_distro_version set to false' do
    expect(chef_run.node['rabbitmq']['use_distro_version']).to eq(false)
  end

  it 'should install the erlang package' do
    expect(chef_run).to install_package('erlang')
  end

  it 'creates a template rabbitmq.config with attributes' do
    expect(chef_run).to create_template('/etc/rabbitmq/rabbitmq.config').with(
      :user => 'root',
      :group => 'root',
      :source => 'rabbitmq.config.erb',
      :mode => 00644)
  end

  describe 'suse' do
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

  describe 'ubuntu' do
    let(:runner) { ChefSpec::ServerRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      node.set['rabbitmq']['version'] = '3.4.4'
      runner.converge(described_recipe)
    end

    include_context 'rabbitmq-stubs'

    it 'should install the logrotate package' do
      expect(chef_run).to install_package('logrotate')
    end

    it 'creates a rabbitmq-server deb in the cache path' do
      expect(chef_run).to create_remote_file_if_missing('/tmp/rabbitmq-server_3.4.4-1_all.deb')
    end

    it 'installs the rabbitmq-server deb_package with the default action' do
      expect(chef_run).to install_dpkg_package('/tmp/rabbitmq-server_3.4.4-1_all.deb')
    end

    describe 'uses distro version' do
      before do
        node.set['rabbitmq']['use_distro_version'] = true
      end

      it 'should install rabbitmq-server package' do
        expect(chef_run).to install_package('rabbitmq-server')
      end

      it 'should install the logrotate package' do
        expect(chef_run).to install_package('logrotate')
      end
    end
  end

  describe 'redhat' do
    let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    it 'creates a rabbitmq-server rpm in the cache path' do
      expect(chef_run).to create_remote_file_if_missing('/tmp/rabbitmq-server-3.4.4-1.noarch.rpm')
      expect(chef_run).to_not create_remote_file_if_missing('/tmp/not-rabbitmq-server-3.4.4-1.noarch.rpm')
    end

    it 'installs the rabbitmq-server rpm_package with the default action' do
      expect(chef_run).to install_rpm_package('/tmp/rabbitmq-server-3.4.4-1.noarch.rpm')
      expect(chef_run).to_not install_rpm_package('/tmp/not-rabbitmq-server-3.4.4-1.noarch.rpm')
    end

    describe 'uses distro version' do
      before do
        node.set['rabbitmq']['use_distro_version'] = true
      end

      it 'should install rabbitmq-server package' do
        expect(chef_run).to install_package('rabbitmq-server')
      end
    end

    it 'loopback_users will not show in config file unless attribute is specified' do
      expect(chef_run).not_to render_file('/etc/rabbitmq/rabbitmq.config').with_content('loopback_users')
    end

    it 'loopback_users is empty when attribute is empty array' do
      node.set['rabbitmq']['loopback_users'] = []
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('loopback_users, []')
    end

    it 'loopback_users can list single user' do
      node.set['rabbitmq']['loopback_users'] = ['foo']
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('loopback_users, [<<"foo">>]')
    end

    it 'loopback_users can list multiple users' do
      node.set['rabbitmq']['loopback_users'] = %w(foo bar)
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('loopback_users, [<<"foo">>,<<"bar">>]')
    end
  end

  describe 'centos' do
    let(:runner) { ChefSpec::ServerRunner.new(CENTOS_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    it 'creates a rabbitmq-server rpm in the cache path' do
      expect(chef_run).to create_remote_file_if_missing('/tmp/rabbitmq-server-3.4.4-1.noarch.rpm')
      expect(chef_run).to_not create_remote_file_if_missing('/tmp/not-rabbitmq-server-3.4.4-1.noarch.rpm')
    end

    it 'installs the rabbitmq-server rpm_package with the default action' do
      expect(chef_run).to install_rpm_package('/tmp/rabbitmq-server-3.4.4-1.noarch.rpm')
      expect(chef_run).to_not install_rpm_package('/tmp/not-rabbitmq-server-3.4.4-1.noarch.rpm')
    end

    it 'includes the `yum-epel` recipe' do
      expect(chef_run).to include_recipe('yum-epel')
    end
    it 'includes the `yum-erlang_solutions` recipe' do
      expect(chef_run).to include_recipe('yum-erlang_solutions')
    end

    describe 'uses distro version' do
      before do
        node.set['rabbitmq']['use_distro_version'] = true
      end

      it 'should install rabbitmq-server package' do
        expect(chef_run).to install_package('rabbitmq-server')
      end
    end
  end

  describe 'fedora' do
    let(:runner) { ChefSpec::ServerRunner.new(FEDORA_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      node.set['rabbitmq']['version'] = '3.4.4'
      runner.converge(described_recipe)
    end

    it 'creates a rabbitmq-server rpm in the cache path' do
      expect(chef_run).to create_remote_file_if_missing('/tmp/rabbitmq-server-3.4.4-1.noarch.rpm')
      expect(chef_run).to_not create_remote_file_if_missing('/tmp/not-rabbitmq-server-3.4.4-1.noarch.rpm')
    end

    it 'installs the rabbitmq-server rpm_package with the default action' do
      expect(chef_run).to install_rpm_package('/tmp/rabbitmq-server-3.4.4-1.noarch.rpm')
      expect(chef_run).to_not install_rpm_package('/tmp/not-rabbitmq-server-3.4.4-1.noarch.rpm')
    end

    describe 'uses distro version' do
      before do
        node.set['rabbitmq']['use_distro_version'] = true
      end

      it 'should install rabbitmq-server package' do
        expect(chef_run).to install_package('rabbitmq-server')
      end
    end
  end

  it 'creates a template rabbitmq.config with attributes' do
    expect(chef_run).to create_template('/etc/rabbitmq/rabbitmq.config').with(
      :user => 'root',
      :group => 'root',
      :source => 'rabbitmq.config.erb',
      :mode => 00644
    )
  end
end
