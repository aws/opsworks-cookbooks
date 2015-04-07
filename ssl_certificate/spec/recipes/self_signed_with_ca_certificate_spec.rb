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

describe 'ssl_certificate_test::self_signed_with_ca_certificate',
         order: :random do
  let(:chef_runner) { ChefSpec::ServerRunner.new }
  let(:node) { chef_runner.node }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:cert_dir) { node['ssl_certificate']['cert_dir'] }
  let(:key_dir) { node['ssl_certificate']['key_dir'] }
  let(:ca_key_path) do
    ::File.join(node['ssl_certificate']['key_dir'], 'CA.key')
  end
  let(:ca_cert_path) do
    ::File.join(node['ssl_certificate']['cert_dir'], 'CA.crt')
  end
  before do
    # write perms required for CA cert generation inside the test
    node.set['ssl_certificate']['key_dir'] = Chef::Config[:file_cache_path]
    node.set['ssl_certificate']['cert_dir'] = Chef::Config[:file_cache_path]
    stub_command('/usr/sbin/apache2 -t').and_return(true)
  end

  it 'creates test.com certificate' do
    expect(chef_run).to create_ssl_certificate('test.com')
      .with_ca_key_path(ca_key_path)
      .with_ca_cert_path(ca_cert_path)
  end

  it 'includes apache2 recipe' do
    expect(chef_run).to include_recipe('apache2')
  end

  it 'includes apache2::mod_ssl recipe' do
    expect(chef_run).to include_recipe('apache2::mod_ssl')
  end

  context 'web_app test.com definition' do
    it 'creates apache2 site' do
      expect(chef_run)
        .to create_template(%r{/sites-available/test\.com\.conf$})
    end
  end

  it 'creates ca.example.org CA certificate from a data bag' do
    expect(chef_run).to create_ssl_certificate('ca.example.org')
      .with_common_name('ca.example.org')
      .with_source('data-bag')
      .with_bag('ssl')
      .with_key_item('ca_key')
      .with_key_item_key('content')
      .with_key_encrypted(true)
      .with_cert_item('ca_cert')
      .with_cert_item_key('content')
  end

  it 'creates example.org certificate from data bag CA certificate' do
    expect(chef_run).to create_ssl_certificate('example.org')
      .with_cert_source('with_ca')
      .with_ca_cert_path(::File.join(cert_dir, 'ca.example.org.pem'))
      .with_ca_key_path(::File.join(key_dir, 'ca.example.org.key'))
  end

  context 'step into ssl_certificate resource' do
    let(:chef_runner) do
      ChefSpec::ServerRunner.new(step_into: %w(ssl_certificate))
    end
    let(:db_ca_key) do
      [
        '-----BEGIN RSA PRIVATE KEY-----',
        'MIIEpQIBAAKCAQEA54mmAezLsd2iUb8NL+lTffiof+G1KCMCamUFa+KXFXhSdTnM',
        'QSLoBrkQ92qGwEbwpmzcI+rUzsnng26/4b4afBiEvNeIORD4VH2fLlGbbXNSw4JS',
        'BAiR+0oaTBhHRXKzXpseGbwrkspiWS9c/gfdpiEVx55Qtuk/n0JgD7scnwn4dT6W',
        'vHCp360yxY5VNnGNrBqqeofG/ZTS9jnJNsH/I7FDadD/Ij1RwYs1lTUz+zUbid2W',
        'bfPVNjncXImzm7Mclcaxh5pvz8UiQ7fhxDRhkKWdxJPljLN1kbp4YZpZECzr3YUz',
        'dcNEtwCXgfIrSgdx3ZSr+8rWa3uaMbYigV5rgQIDAQABAoIBAQCyJs1eyc5pSvls',
        'IK6K4OLnGH699vMmsNlY9+XV/wD0+iGoJRKuQ6d4FMmjNYn9RBhCVZyE3lljyyKh',
        'lIN7tIQ4W702eDhOgGoyyH3Ea/JFouhZmlp01AtO6NOXHU8pdnnhH0Vn08tLJQHL',
        'UZAhvfejre1OLNg6BPp5Fd9H+1aoXtLuBEgQNNFU4LUdejtL6f0hqCdULckL/HeQ',
        'T4mg2jlp6I2zr9E6bbv4/OqxjzbIJDwkVbXIhRYb+fltor6/CfwZZh2m3d56pRl/',
        'tORjuNpdvlxc22/09SfovPX2EINMBEg4LiOcjgQWvqPSPnPrT9YReS+ktANor3eK',
        'iU3s4pMJAoGBAPSWoKHaF7gs8Zs3qyC+di/86+tJsbI57cZOKjCICTpx8J7SZMbd',
        'lB8XjoD8s05kz7GlmgEcJezd9TUPMngPiSx9c58XmCI7ZG+eKVZsvAkNT3HOFlx+',
        '5Z+W77ofirxKi5XV1Q3lC1thJOCpnFeD+CwI7v4gF2Spbnp0QMzpTH0TAoGBAPJX',
        'JJoEoZ1yL9RIBk/SSmptwdNIaDGcizNgwewpnDciORC5l3gSTgxHt5UEFYl6cDxe',
        '43MM415vRouLYLGX1i0KFpUT2SJK61prPkpllllP581/rNtOK+npWAaGgNZUVvXk',
        '+LHKqpEGz0NgA9ZDMUpFb5sqi2iYlHgI6jBE0aubAoGBAM3zR68BhZd/wLGCXoZj',
        '2gDuZ3jnxMjeHmksyDm1Uo/0ATi60EDjsyW7IDNclV8dZAWh+9uTaBvbie3zrfuK',
        'mWbs+76qj1/Dwv55nzU2ud6lZo/diNa5w4BuB84hYSDLZF32gEAC7V00n2jNaOgI',
        'J6BspVE2lHwebviNi0L/73ghAoGBAKMfiWGrEGZ8wDkyKh18vd6Z9sgTix8p8oEo',
        '9h/TenWaMbNSWeTW3XZip+5Ei4K4yee5L3z4BexBFslDjli8jcxPaBf8/kGZEIcS',
        'fSFy9Bs2MCAheuc73U9cZIYv73VV3Bs0fzqd4uYwIT+G185X+Eu4JYHax3AmlHmf',
        '9pN7H29VAoGAAsyGwjPUREZ99g+AL68DQpSf8MhT9d2YsIwzu548bHpJZ5JCX2Hk',
        'l7APHlvTUFu21/nvCSDBO+fQxLBnUO3QM2Cys1WJBvgMTCMf9TCDohkvLJmDw0Y/',
        '0Np0kSanVp1v2MBtkIj5YdFNu9JZX6mI0cYevZqRvkqtqHKl434IV5Q=',
        '-----END RSA PRIVATE KEY-----'
      ].join("\n")
    end
    let(:db_ca_cert) do
      [
        '-----BEGIN CERTIFICATE-----',
        'MIIEATCCAumgAwIBAgIBADANBgkqhkiG9w0BAQUFADCBoTELMAkGA1UEBhMCRVMx',
        'EDAOBgNVBAgTB0JpemthaWExDzANBgNVBAcTBkJpbGJhbzEaMBgGA1UECgwRQ29u',
        'cXVlciB0aGUgV29ybGQxEzARBgNVBAsMCkV2ZXJ5dGhpbmcxFzAVBgNVBAMMDmNh',
        'LmV4YW1wbGUub3JnMSUwIwYJKoZIhvcNAQkBDBZldmVyeXRoaW5nQGV4YW1wbGUu',
        'b3JnMB4XDTE0MTIyNjIzMTk1MFoXDTE0MTIyNzAwMjA0MFowgaExCzAJBgNVBAYT',
        'AkVTMRAwDgYDVQQIEwdCaXprYWlhMQ8wDQYDVQQHEwZCaWxiYW8xGjAYBgNVBAoM',
        'EUNvbnF1ZXIgdGhlIFdvcmxkMRMwEQYDVQQLDApFdmVyeXRoaW5nMRcwFQYDVQQD',
        'DA5jYS5leGFtcGxlLm9yZzElMCMGCSqGSIb3DQEJAQwWZXZlcnl0aGluZ0BleGFt',
        'cGxlLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOeJpgHsy7Hd',
        'olG/DS/pU334qH/htSgjAmplBWvilxV4UnU5zEEi6Aa5EPdqhsBG8KZs3CPq1M7J',
        '54Nuv+G+GnwYhLzXiDkQ+FR9ny5Rm21zUsOCUgQIkftKGkwYR0Vys16bHhm8K5LK',
        'YlkvXP4H3aYhFceeULbpP59CYA+7HJ8J+HU+lrxwqd+tMsWOVTZxjawaqnqHxv2U',
        '0vY5yTbB/yOxQ2nQ/yI9UcGLNZU1M/s1G4ndlm3z1TY53FyJs5uzHJXGsYeab8/F',
        'IkO34cQ0YZClncST5YyzdZG6eGGaWRAs692FM3XDRLcAl4HyK0oHcd2Uq/vK1mt7',
        'mjG2IoFea4ECAwEAAaNCMEAwHQYDVR0OBBYEFFlmVAuc4kzsdq+CNNp6LiraGcdz',
        'MA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBBQUA',
        'A4IBAQAAujEY3Ga1DQla1c/xnyjGzYCn846Hm1Y4YpTMf/esjDjaPQnuBDkB2sj1',
        'AqHe3UwXnULKAbpBAc43wxKY7eM+PgUnggqiLU9pHEIs7NozB0mVOok2iHpFdQUM',
        '10UpMyDXvh6JVQRyP/3zwU86oA3Ia9FGnFCmwc2yEovWs93mqw0DfXKohM3iBq/W',
        'q8s9DimjJQInO0tcrgt34IJ+f8FfUBzF5+NDZUEKz9Odd6qq5U1apWOoZaqzzpoS',
        '7I6thT5vWCjLXueG9le0slCHyUk7cBR1eT7edtpk95IH8cSU2DonUgvOBrYy0Rzt',
        'QSxMwODsN+gk6FIJmCQzRUMFixj8',
        '-----END CERTIFICATE-----'
      ].join("\n")
    end
    before do
      allow(Chef::EncryptedDataBagItem).to receive(:load)
        .with('ssl', 'ca_key', nil).and_return('content' => db_ca_key)
      allow(Chef::DataBagItem).to receive(:load).with('ssl', 'ca_cert')
        .and_return('content' => db_ca_cert)

      allow(::File).to receive(:exist?).and_call_original
      allow(::File).to receive(:exist?)
        .with(::File.join(cert_dir, 'ca.example.org.pem')).and_return(true)
      allow(::File).to receive(:exist?)
        .with(::File.join(key_dir, 'ca.example.org.key')).and_return(true)
      allow(::IO).to receive(:read).and_call_original
      allow(::IO).to receive(:read)
        .with(::File.join(cert_dir, 'ca.example.org.pem'))
        .and_return(db_ca_cert)
      allow(::IO).to receive(:read)
        .with(::File.join(key_dir, 'ca.example.org.key')).and_return(db_ca_key)
    end

    it 'runs without errors' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates test.com key' do
      expect(chef_run).to create_file('test.com SSL certificate key')
        .with_path(::File.join(key_dir, 'test.com.key'))
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
    end

    it 'creates test.com certificate' do
      expect(chef_run).to create_file('test.com SSL public certificate')
        .with_path(::File.join(cert_dir, 'test.com.pem'))
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
    end

    it 'creates ca.example.org CA certificate key' do
      expect(chef_run).to create_file('ca.example.org SSL certificate key')
        .with_path(::File.join(key_dir, 'ca.example.org.key'))
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
        .with_content(db_ca_key)
    end

    it 'creates ca.example.org CA certificate' do
      expect(chef_run).to create_file('ca.example.org SSL public certificate')
        .with_path(::File.join(cert_dir, 'ca.example.org.pem'))
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
        .with_content(db_ca_cert)
    end

    it 'creates example.org key' do
      expect(chef_run).to create_file('example.org SSL certificate key')
        .with_path(::File.join(key_dir, 'example.org.key'))
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
    end

    it 'creates example.org certificate' do
      expect(chef_run).to create_file('example.org SSL public certificate')
        .with_path(::File.join(cert_dir, 'example.org.pem'))
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
    end
  end
end
