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

describe 'ssl_certificate_test::subject_alternate_names', order: :random do
  let(:chef_runner) { ChefSpec::ServerRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }

  it 'creates subject_alternate_names certificate' do
    expect(chef_run).to create_ssl_certificate('subject_alternate_names')
      .with_key_source('self-signed')
      .with_cert_source('self-signed')
  end

  it 'creates subject_alternate_names2 certificate' do
    expect(chef_run).to create_ssl_certificate('subject_alternate_names2')
      .with_key_source('self-signed')
      .with_cert_source('self-signed')
  end

  context 'step into ssl_certificate resource' do
    let(:chef_runner) do
      ChefSpec::ServerRunner.new(step_into: %w(ssl_certificate))
    end

    it 'runs without errors' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates subject_alternate_names key from an encrypted data bag' do
      expect(chef_run)
        .to create_file('subject_alternate_names SSL certificate key')
        .with_path('/etc/ssl/private/subject_alternate_names.key')
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
    end

    it 'creates subject_alternate_names certificate from a data bag' do
      expect(chef_run)
        .to create_file('subject_alternate_names SSL public certificate')
        .with_path('/etc/ssl/certs/subject_alternate_names.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
    end

    it 'creates subject_alternate_names2 key from an encrypted data bag' do
      expect(chef_run)
        .to create_file('subject_alternate_names2 SSL certificate key')
        .with_path('/etc/ssl/private/subject_alternate_names2.key')
        .with_owner('root')
        .with_group('root')
        .with_mode(00600)
    end

    it 'creates subject_alternate_names2 certificate from a data bag' do
      expect(chef_run)
        .to create_file('subject_alternate_names2 SSL public certificate')
        .with_path('/etc/ssl/certs/subject_alternate_names2.pem')
        .with_owner('root')
        .with_group('root')
        .with_mode(00644)
    end
  end
end
