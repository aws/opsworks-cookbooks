# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014-2015 Onddo Labs, SL. (www.onddo.com)
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

describe 'ssl_certificate_test::default', order: :random do
  let(:chef_runner) { ChefSpec::ServerRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  let(:fqdn) { 'ssl-certificate.example.com' }
  let(:dummy_key) do
    '-----BEGIN PRIVATE KEY-----[...]-----END PRIVATE KEY-----'
  end
  let(:dummy_cert) do
    '-----BEGIN CERTIFICATE-----[...]-----END CERTIFICATE-----'
  end
  before do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    node.automatic['fqdn'] = fqdn

    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:exist?)
      .with('/etc/ssl/certs/dummy6-attributes.pem').and_return(true)
    allow(::File).to receive(:exist?)
      .with('/etc/ssl/private/dummy6-attributes.key').and_return(true)
    allow(::IO).to receive(:read).and_call_original
    allow(::IO).to receive(:read)
      .with('/etc/ssl/certs/dummy6-attributes.pem').and_return(dummy_cert)
    allow(::IO).to receive(:read)
      .with('/etc/ssl/private/dummy6-attributes.key').and_return(dummy_key)
  end

  it 'creates dummy1 certificate' do
    expect(chef_run).to create_ssl_certificate('dummy1')
  end

  it 'creates dummy2 certificate' do
    expect(chef_run).to create_ssl_certificate('dummy2')
      .with_key_source('self-signed')
      .with_cert_source('self-signed')
  end

  it 'creates dummy3 certificate' do
    expect(chef_run).to create_ssl_certificate('dummy3')
      .with_source('self-signed')
      .with_years(5)
  end

  it 'creates dummy4 certificate' do
    expect(chef_run).to create_ssl_certificate('dummy4')
      .with_source('self-signed')
      .with_country('Bilbao')
  end

  it 'creates dummy5 certificate' do
    expect(chef_run).to create_ssl_certificate('dummy5-data-bag')
      .with_owner('www-data')
      .with_group('www-data')
  end

  it 'creates dummy6 certificate' do
    expect(chef_run).to create_ssl_certificate('dummy6-attributes')
  end

  it 'creates dummy7 certificate' do
    expect(chef_run).to create_ssl_certificate('dummy7')
  end

  it 'creates FQDN certificate' do
    expect(chef_run).to create_ssl_certificate(fqdn)
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
    before do
      allow(Chef::EncryptedDataBagItem).to receive(:load)
        .with('ssl', 'key', nil).and_return('content' => db_key)
      allow(Chef::DataBagItem).to receive(:load).with('ssl', 'cert')
        .and_return('content' => db_cert)
    end

    it 'runs without errors' do
      expect { chef_run }.to_not raise_error
    end

    (1..4).each do |i|
      it "creates dummy#{i} key" do
        expect(chef_run).to create_file("dummy#{i} SSL certificate key")
          .with_path("/etc/ssl/private/dummy#{i}.key")
          .with_owner('root')
          .with_group('root')
          .with_mode(00600)
      end

      it "creates dummy#{i} certificate" do
        expect(chef_run).to create_file("dummy#{i} SSL public certificate")
          .with_path("/etc/ssl/certs/dummy#{i}.pem")
          .with_owner('root')
          .with_group('root')
          .with_mode(00644)
      end
    end # (1..4).step.each

    it 'creates dummy5 key from an encrypted data bag' do
      expect(chef_run).to create_file('dummy5-data-bag SSL certificate key')
        .with_path('/etc/ssl/private/dummy5-data-bag.key')
        .with_owner('www-data')
        .with_group('www-data')
        .with_mode(00600)
        .with_content(db_key)
    end

    it 'creates dummy5 certificate from a data bag' do
      expect(chef_run).to create_file('dummy5-data-bag SSL public certificate')
        .with_path('/etc/ssl/certs/dummy5-data-bag.pem')
        .with_owner('www-data')
        .with_group('www-data')
        .with_mode(00644)
        .with_content(db_cert)
    end

    it 'creates dummy5 combined certificate from a data bag' do
      expect(chef_run)
        .to create_file(
          'dummy5-data-bag SSL intermediary chain combined certificate'
        )
        .with_path('/etc/ssl/certs/dummy5-data-bag.pem.chained.pem')
        .with_owner('www-data')
        .with_group('www-data')
        .with_mode(00644)
        .with_content(db_cert)
    end

    it 'creates dummy6 key from node attributes' do
      expect(chef_run).to create_file('dummy6-attributes SSL certificate key')
        .with_path('/etc/ssl/private/dummy6-attributes.key')
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
        .with_content(node['dummy6-attributes']['ssl_key']['content'])
    end

    it 'creates dummy6 certificate from node attributes' do
      expect(chef_run)
        .to create_file('dummy6-attributes SSL public certificate')
        .with_path('/etc/ssl/certs/dummy6-attributes.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
        .with_content(node['dummy6-attributes']['ssl_cert']['content'])
    end

    it 'creates dummy6 combined certificate from node attributes' do
      expect(chef_run)
        .to create_file(
          'dummy6-attributes SSL intermediary chain combined certificate'
        )
        .with_path('/etc/ssl/certs/dummy6-attributes.pem.chained.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
        .with_content(node['dummy6-attributes']['ssl_cert']['content'])
    end

    it 'creates dummy7 key from node attributes' do
      expect(chef_run).to create_file('dummy7 SSL certificate key')
        .with_path('/etc/ssl/private/dummy6-attributes.key')
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
    end

    it 'creates dummy7 certificate from node attributes' do
      expect(chef_run)
        .to create_file('dummy7 SSL public certificate')
        .with_path('/etc/ssl/certs/dummy6-attributes.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
    end

    it 'creates dummy7 combined certificate from node attributes' do
      expect(chef_run)
        .to create_file(
          'dummy7 SSL intermediary chain combined certificate'
        )
        .with_path('/etc/ssl/certs/dummy7.pem.chained.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
    end

    it 'creates FQDN key' do
      expect(chef_run).to create_file("#{fqdn} SSL certificate key")
        .with_path("/etc/ssl/private/#{fqdn}.key")
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
    end

    it 'creates FQDN certificate' do
      expect(chef_run)
        .to create_file("#{fqdn} SSL public certificate")
        .with_path("/etc/ssl/certs/#{fqdn}.pem")
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
    end

    context 'with FreeBSD' do
      let(:chef_runner) do
        ChefSpec::ServerRunner.new(
          step_into: %w(ssl_certificate), platform: 'freebsd', version: '9.2'
        )
      end
      before do
        stub_command('/usr/local/sbin/httpd -t').and_return(true)
        allow(::File).to receive(:exist?)
          .with('/etc/ssl/dummy6-attributes.pem').and_return(true)
        allow(::File).to receive(:exist?)
          .with('/etc/ssl/dummy6-attributes.key').and_return(true)
        allow(::IO).to receive(:read)
          .with('/etc/ssl/dummy6-attributes.pem').and_return(dummy_cert)
        allow(::IO).to receive(:read)
          .with('/etc/ssl/dummy6-attributes.key').and_return(dummy_key)
      end

      it 'creates dummy1 key for wheel group' do
        expect(chef_run).to create_file('dummy1 SSL certificate key')
          .with_path('/etc/ssl/dummy1.key')
          .with_owner('root')
          .with_group('wheel')
          .with_mode(00600)
      end

      it 'creates dummy1 certificate for wheel group' do
        expect(chef_run).to create_file('dummy1 SSL public certificate')
          .with_path('/etc/ssl/dummy1.pem')
          .with_owner('root')
          .with_group('wheel')
          .with_mode(00644)
      end
    end # context with FreeBSD
  end # context step into ssl_certificate resource
end
