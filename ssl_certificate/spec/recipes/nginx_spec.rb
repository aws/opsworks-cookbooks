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

describe 'ssl_certificate_test::nginx', order: :random do
  let(:chef_runner) { ChefSpec::ServerRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  let(:fqdn) { 'ssl-certificate.example.com' }
  before do
    node.automatic['fqdn'] = fqdn
    stub_command('which nginx').and_return(true)
  end

  it 'creates chain-data-bag certificate' do
    expect(chef_run).to create_ssl_certificate('chain-data-bag')
  end

  it 'includes nginx recipe' do
    expect(chef_run).to include_recipe('nginx')
  end

  it 'creates nginx virtualhost template' do
    expect(chef_run)
      .to create_template('/etc/nginx/sites-available/ssl_certificate')
      .with_source('nginx_vhost.erb')
      .with_mode(00644)
      .with_owner('root')
      .with_group('root')
  end

  it 'enables nginx virtualhost' do
    expect(chef_run).to run_execute('nxensite ssl_certificate')
  end
end
