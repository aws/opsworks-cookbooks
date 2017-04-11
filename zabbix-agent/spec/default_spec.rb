require 'spec_helper'

describe 'zabbix-agent::default' do
  context 'with default settings' do
    cached(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

    it 'includes zabbix-agent::service to insure the zabbix agent will run' do
      expect(chef_run).to include_recipe('zabbix-agent::service')
    end

    it 'includes zabbix-agent::configure to configure the zabbix agent' do
      expect(chef_run).to include_recipe('zabbix-agent::configure')
    end

    it 'includes zabbix-agent::install to install the zabbix agent' do
      expect(chef_run).to include_recipe('zabbix-agent::install')
    end

    it 'adds the group "zabbix"' do
      expect(chef_run).to create_group('zabbix')
    end

    it 'adds the user "zabbix" to run the zabbix_agentd' do
      expect(chef_run).to create_user('zabbix')
    end

    it 'creates the directory /opt/zabbix owned by root.root and mode 755 to store the application install.' do
      expect(chef_run).to create_directory('/opt/zabbix').with(
        user:   'zabbix',
        group:  'zabbix',
        mode:   '755'
      )
    end

    it 'creates the directory /etc/zabbix owned by root.root and mode 755 to store configurations, scripts and UserParamiters' do
      expect(chef_run).to create_directory('/etc/zabbix').with(
        user:   'root',
        group:  'root',
        mode:   '755'
      )
    end

    it 'creates the directory /etc/zabbix/zabbix_agentd.d owned by root.root and mode 755 to store configurations, UserParamiters' do
      expect(chef_run).to create_directory('/etc/zabbix/zabbix_agentd.d').with(
        user:   'root',
        group:  'root',
        mode:   '755'
      )
    end

    it 'creates the directory /etc/zabbix/scripts owned by root.root and mode 755 to store custom scripts' do
      expect(chef_run).to create_directory('/etc/zabbix/scripts').with(
        user:   'root',
        group:  'root',
        mode:   '755'
      )
    end

    it 'creates the directory /var/log/zabbix owned by zabbix.zabbix and mode 755 to store zabbix_agentd logs' do
      expect(chef_run).to create_directory('/var/log/zabbix').with(
        user:   'zabbix',
        group:  'zabbix',
        mode:   '755'
      )
    end

    it 'creates the directory /var/run/zabbix owned by zabbix.zabbix and mode 755 to store the PID file' do
      expect(chef_run).to create_directory('/var/run/zabbix').with(
        user:   'zabbix',
        group:  'zabbix',
        mode:   '755'
      )
    end

    # default node['zabbix']['agent']['install_method'] = package
    it 'includes zabbix-agent::install_package to install the zabbix agent from the package' do
      expect(chef_run).to include_recipe('zabbix-agent::install_package')
    end

    it 'installs the zabbix-agent package' do
      expect(chef_run).to install_package('zabbix-agent')
    end

    it 'skips creating user_params.conf by default due to no entries in array' do
      expect(chef_run).to_not create_template('user_params.conf')
    end

    it 'creates the template /etc/zabbix/zabbix_agentd.conf with the default configuration' do
      expect(chef_run).to create_template('zabbix_agentd.conf').with(
        path:   '/etc/zabbix/zabbix_agentd.conf',
        user:   'root',
        group:  'root',
        mode:   '644'
      )
    end

    it 'renders the file with content from ./spec/rendered_templates/zabbix_agentd.conf' do
      zabbix_agentd_conf = File.read('./spec/rendered_templates/zabbix_agentd.conf')
      expect(chef_run).to render_file('/etc/zabbix/zabbix_agentd.conf').with_content(zabbix_agentd_conf)
    end

    it 'skips creating the zabbix-agent init script because the package includes one' do
      expect(chef_run).to_not create_template('/etc/init.d/zabbix-agent')
    end

    it 'starts and enables the zabbix-agent service with an explicit action' do
      expect(chef_run).to start_service('zabbix-agent')
      expect(chef_run).to enable_service('zabbix-agent')
    end
  end

  context 'if installed on Ubuntu it' do
    cached(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe) }

    it 'includes the apt cookbook' do
      expect(chef_run).to include_recipe('apt')
    end

    it 'adds the apt repository for zabbix' do
      expect(chef_run).to add_apt_repository('zabbix').with(
        uri: 'http://repo.zabbix.com/zabbix/2.4/ubuntu/',
        components: ['main'],
        key: 'http://repo.zabbix.com/zabbix-official-repo.key'
      )
    end

    it 'installs the zabbix-agent package' do
      expect(chef_run).to install_package('zabbix-agent')
    end
  end

  context 'if installed on CentOS it' do
    cached(:chef_run) { ChefSpec::ServerRunner.new(platform: 'centos', version: '6.5').converge(described_recipe) }

    it 'includes the yum cookbook' do
      expect(chef_run).to include_recipe('yum')
    end

    it 'adds the yum repository for zabbix' do
      expect(chef_run).to create_yum_repository('zabbix').with(
        repositoryid: 'zabbix',
        description: 'Zabbix Official Repository',
        baseurl: 'http://repo.zabbix.com/zabbix/2.4/rhel/$releasever/$basearch/',
        gpgkey: 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        sslverify: false
      )
    end

    it 'adds the yum repository for zabbix-non-supported' do
      expect(chef_run).to create_yum_repository('zabbix-non-supported').with(
        repositoryid: 'zabbix-non-supported',
        description: 'Zabbix Official Repository non-supported - $basearch',
        baseurl: 'http://repo.zabbix.com/zabbix/2.4/rhel/$releasever/$basearch/',
        gpgkey: 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        sslverify: false
      )
    end

    it 'installs the zabbix-agent package' do
      expect(chef_run).to install_package('zabbix-agent')
    end
  end
end
