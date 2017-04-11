#
# Author:: Stanislav Bogatyrev (<realloc@realloc.spb.ru>)
# Copyright:: Copyright (c) 2015 Stanislav Bogatyrev
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

describe 'ssl_certificate::attr_apply', order: :random do
  let(:chef_runner) { ChefSpec::ServerRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  let(:fqdn) { 'ssl-certificate.example.com' }

  before do
    node.automatic['fqdn'] = fqdn
    node.override['ssl_certificate']['items'] = [
      {
        'name' => 'ssl-certificate.example.com',
        'source' => 'self-signed'
      }
    ]
  end

  it 'creates example self-signed certificate' do
    expect(chef_run).to create_ssl_certificate('ssl-certificate.example.com')
      .with_key_source('self-signed')
      .with_cert_source('self-signed')
  end
end
