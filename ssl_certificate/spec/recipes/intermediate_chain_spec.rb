# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe 'ssl_certificate_test::intermediate_chain', order: :random do
  let(:chef_runner) { ChefSpec::ServerRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  let(:fqdn) { 'ssl-certificate.example.com' }
  before do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    node.automatic['fqdn'] = fqdn
  end

  it 'creates chain-data-bag certificate' do
    expect(chef_run).to create_ssl_certificate('chain-data-bag')
  end

  it 'creates chain-data-bag2 certificate' do
    expect(chef_run).to create_ssl_certificate('chain-data-bag2')
  end

  it 'includes apache2 recipe' do
    expect(chef_run).to include_recipe('apache2')
  end

  it 'includes apache2::mod_ssl recipe' do
    expect(chef_run).to include_recipe('apache2::mod_ssl')
  end

  context 'web_app fqdn definition' do
    it 'creates apache2 site' do
      expect(chef_run)
        .to create_template(%r{/sites-available/#{Regexp.escape(fqdn)}\.conf$})
    end
  end

  context 'step into ssl_certificate resource' do
    let(:chef_runner) do
      ChefSpec::ServerRunner.new(step_into: %w(ssl_certificate))
    end
    let(:db_key) do
      '-----BEGIN PRIVATE KEY-----[...]-----END PRIVATE KEY-----'
    end
    let(:db_cert) do
      '-----BEGIN CERTIFICATE-----[...]-----END CERTIFICATE-----'
    end
    let(:db_chain) do
      '-----BEGIN CERTIFICATE-----[...] CHAIN [...]-----END CERTIFICATE-----'
    end
    let(:db_chain_combined) { "#{db_cert}\n#{db_chain}" }
    before do
      allow(Chef::EncryptedDataBagItem).to receive(:load)
        .with('ssl', 'key', nil).and_return('content' => db_key)
      allow(Chef::DataBagItem).to receive(:load).with('ssl', 'cert')
        .and_return('content' => db_cert)
      allow(Chef::DataBagItem).to receive(:load).with('ssl', 'chain')
        .and_return('content' => db_chain)
    end

    it 'runs without errors' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates chain-data-bag key from an encrypted data bag' do
      expect(chef_run).to create_file('chain-data-bag SSL certificate key')
        .with_path('/etc/ssl/private/chain-data-bag.key')
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
        .with_content(db_key)
    end

    it 'creates chain-data-bag certificate from a data bag' do
      expect(chef_run).to create_file('chain-data-bag SSL public certificate')
        .with_path('/etc/ssl/certs/chain-data-bag.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
        .with_content(db_cert)
    end

    it 'creates chain-data-bag chain certificate from a data bag' do
      expect(chef_run)
        .to create_file('chain-data-bag SSL intermediary chain certificate')
        .with_path('/etc/ssl/certs/dummy-ca-bundle.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
        .with_content(db_chain)
    end

    it 'creates chain-data-bag chain combined certificate from a data bag' do
      expect(chef_run)
        .to create_file(
          'chain-data-bag SSL intermediary chain combined certificate'
        )
        .with_path('/etc/ssl/certs/chain-data-bag.pem.chained.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
        .with_content(db_chain_combined)
    end

    it 'creates chain-data-bag2 key from node attributes' do
      expect(chef_run).to create_file('chain-data-bag2 SSL certificate key')
        .with_path('/etc/ssl/private/chain-data-bag2.key')
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
        .with_content(node['chain-data-bag2']['ssl_key']['content'])
    end

    it 'creates chain-data-bag2 certificate from node attributes' do
      expect(chef_run)
        .to create_file('chain-data-bag2 SSL public certificate')
        .with_path('/etc/ssl/certs/chain-data-bag2.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
        .with_content(node['chain-data-bag2']['ssl_cert']['content'])
    end

    it 'creates chain-data-bag2 chain certificate from node attributes' do
      expect(chef_run)
        .to create_file('chain-data-bag2 SSL intermediary chain certificate')
        .with_path('/etc/ssl/certs/dummy-ca-bundle2.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
        .with_content(node['chain-data-bag2']['ssl_chain']['content'])
    end

    it 'creates chain-data-bag2 chain combined certificate from node '\
       'attributes' do
      expect(chef_run)
        .to create_file(
          'chain-data-bag2 SSL intermediary chain combined certificate'
        )
        .with_path('/etc/ssl/certs/chain-data-bag2.pem.chained.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
        .with_content([
          node['chain-data-bag2']['ssl_cert']['content'],
          node['chain-data-bag2']['ssl_chain']['content']
        ].join("\n"))
    end
  end
end
