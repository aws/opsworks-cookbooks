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
require 'support/template_render'
require 'service_helpers'

describe 'ssl_certificate apache partial template', order: :random do
  let(:web_service) { 'apache' }
  let(:template) { TemplateRender.new("#{web_service}.erb") }
  let(:node) { template.node }

  let(:ssl_key) { '/etc/ssl/private/cert.key' }
  let(:ssl_cert) { '/etc/ssl/certs/cert.pem' }
  let(:minimum_variables) { { ssl_key: ssl_key, ssl_cert: ssl_cert } }
  let(:variables) { minimum_variables }
  before { allow(Chef::Log).to receive(:warn) }

  context 'with old node["ssl_certificate"]["web"] configuration' do
    before do
      node.set['ssl_certificate']['web']['protocols'] = 'backwards'
    end

    it 'maintains backwards compatibility' do
      expect(template.render(variables))
        .to match(/^\s*SSLProtocol\s+backwards/)
    end

    it 'print deprecated warning' do
      expect(Chef::Log).to receive(:warn).with(
        "[DEPRECATED] Use `node['ssl_certificate']['service']['compatibility']"\
        "` instead of `node['ssl_certificate']['web']['compatibility']`."
      )
      template.render(variables)
    end
  end

  it 'renders without errors' do
    expect { template.render(variables) }.to_not raise_error
  end

  it 'enables ssl engine' do
    expect(template.render(variables)).to match(/^\s+SSLEngine on/)
  end

  it 'sets ssl cert' do
    expect(template.render(variables))
      .to match(/^\s*SSLCertificateFile\s+#{Regexp.escape(ssl_cert)}/)
  end

  it 'sets ssl key' do
    expect(template.render(variables))
      .to match(/^\s*SSLCertificateKeyFile\s+#{Regexp.escape(ssl_key)}/)
  end

  it 'does not set ssl chain cert' do
    expect(template.render(variables))
      .to_not match(/^\s*SSLCertificateChainFile/)
  end

  it 'does not set ssl ca cert' do
    expect(template.render(variables))
      .to_not match(/^\s*SSLCACertificateFile/)
  end

  it 'enables HSTS' do
    expect(template.render(variables))
      .to match(/^\s*Header add Strict-Transport-Security/)
  end

  context 'with SSL intermediary chain' do
    let(:ssl_chain) { '/etc/ssl/certs/chain.pem' }
    let(:variables) { minimum_variables.merge(ssl_chain: ssl_chain) }

    it 'sets ssl chain cert' do
      expect(template.render(variables))
        .to match(/^\s*SSLCertificateChainFile\s+#{Regexp.escape(ssl_chain)}/)
    end
  end # context with SSL intermediary chain

  context 'without HSTS enabled' do
    before { node.set['ssl_certificate']['service']['use_hsts'] = false }

    it 'does not enable HSTS' do
      expect(template.render(variables))
        .to_not match(/^\s*Header add Strict-Transport-Security/)
    end
  end

  shared_examples 'compatibility configuration' do |level|
    let(:config) { node['ssl_certificate']['service'][level.to_s] }

    it 'contains description' do
      expect(config['description']).to be_a(String)
    end

    it 'contains protocols' do
      expect(config[web_service]['protocols']).to be_a(String)
    end

    it 'contains ciphers' do
      expect(config['cipher_suite']).to be_a(String)
    end

    it 'adds compatibility comment' do
      description_regexp = Regexp.escape(config['description'])
      expect(template.render(variables))
        .to match(/^\s*# #{description_regexp}/)
    end

    it 'adds protocols' do
      protocols_regexp = Regexp.escape(config[web_service]['protocols'])
      expect(template.render(variables))
        .to match(/^\s*SSLProtocol\s+#{protocols_regexp}/)
    end

    it 'adds ciphers' do
      ciphers_regexp = Regexp.escape(config['cipher_suite'])
      expect(template.render(variables))
        .to match(/^\s*SSLCipherSuite\s+#{ciphers_regexp}/)
    end
  end

  %w(
    old
    intermediate
    modern
  ).each do |level|
    context "with #{level} compatibility in attributes" do
      before do
        node.set['ssl_certificate']['service']['compatibility'] = level.to_sym
      end

      it_behaves_like 'compatibility configuration', level
    end

    context "with #{level} compatibility in template variables" do
      let(:variables) { minimum_variables.merge(ssl_compatibility: level) }

      it_behaves_like 'compatibility configuration', level
    end
  end
end
