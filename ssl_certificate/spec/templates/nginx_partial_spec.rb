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

describe 'ssl_certificate nginx partial template', order: :random do
  let(:web_service) { 'nginx' }
  let(:template) { TemplateRender.new("#{web_service}.erb") }
  let(:node) { template.node }

  let(:ssl_key) { '/etc/ssl/private/cert.key' }
  let(:ssl_cert) { '/etc/ssl/certs/cert.pem' }
  let(:minimum_variables) { { ssl_key: ssl_key, ssl_cert: ssl_cert } }
  let(:variables) { minimum_variables }

  it 'renders without errors' do
    expect { template.render(variables) }.to_not raise_error
  end

  it 'sets ssl cert' do
    expect(template.render(variables))
      .to match(/^\s*ssl_certificate\s+#{Regexp.escape(ssl_cert)}/)
  end

  it 'sets ssl key' do
    expect(template.render(variables))
      .to match(/^\s*ssl_certificate_key\s+#{Regexp.escape(ssl_key)}/)
  end

  it 'enables HSTS' do
    expect(template.render(variables))
      .to match(/^\s*add_header Strict-Transport-Security/)
  end

  context 'with nginx >= 1.3.7' do
    before { node.set['nginx']['version'] = '1.3.7' }

    it 'enables stapling' do
      expect(template.render(variables))
        .to match(/^\s*ssl_stapling on;/)
    end
  end

  context 'with nginx < 1.3.7' do
    before { node.set['nginx']['version'] = '1.3.6' }

    it 'does not enable stapling' do
      expect(template.render(variables))
        .to_not match(/^\s*ssl_stapling on;/)
    end
  end

  context 'without HSTS enabled' do
    before { node.set['ssl_certificate']['service']['use_hsts'] = false }

    it 'does not enable HSTS' do
      expect(template.render(variables))
        .to_not match(/^\s*add_header Strict-Transport-Security/)
    end
  end

  context 'without stapling' do
    before { node.set['ssl_certificate']['service']['use_stapling'] = false }

    it 'does not enable stapling' do
      expect(template.render(variables))
        .to_not match(/^\s*ssl_stapling on;/)
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
      protocols = config[web_service]['protocols']
      protocols = protocols.call if protocols.respond_to?(:call)
      protocols_regexp = Regexp.escape(protocols)
      expect(template.render(variables))
        .to match(/^\s*ssl_protocols\s+#{protocols_regexp};/)
    end

    it 'adds ciphers' do
      ciphers_regexp = Regexp.escape(config['cipher_suite'])
      expect(template.render(variables))
        .to match(/^\s*ssl_ciphers\s+#{ciphers_regexp};/)
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
