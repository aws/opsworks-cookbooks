#
# Copyright 2013, Chef Software, Inc.
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

require File.expand_path('../support/helpers', __FILE__)

describe 'rabbitmq_test::lwrps' do
  include Helpers::RabbitMQ

  # plugins
  it 'enabled the rabbitmq_stomp plugin' do
    assert(plugin_enabled?('rabbitmq_stomp'))
  end

  it 'disabled the nonexistant_plugin and rabbitmq_shovel plugin' do
    assert(!plugin_enabled?('rabbitmq_shovel'))
    assert(!plugin_enabled?('nonexistant_plugin'))
  end

  # users
  it 'enabled the kitchen1 and kitchen3 users' do
    assert(user_enabled?('kitchen1'))
    assert(user_enabled?('kitchen3'))
  end

  it 'disabled the nonexistant_user and kitchen2 users' do
    assert(!user_enabled?('kitchen2'))
    assert(!user_enabled?('nonexistant_user'))
  end

  # policies
  it 'enabled the example policies from the default attributes' do
    assert(policy_enabled?('ha-all'))
    assert(policy_enabled?('ha-two'))
  end

  it 'disabled the nonexistant_policy' do
    assert(!policy_enabled?('nonexistant_policy'))
  end

  # vhosts
  it 'enabled the kitchen vhost' do
    assert(vhost_enabled?('kitchen'))
  end

  it 'disabled the nonexistant_vhost' do
    assert(!vhost_enabled?('nonexistant_vhost'))
  end
end
