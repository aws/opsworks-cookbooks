#
# Copyright 2012-2013, Chef Software, Inc. <legal@chef.io>
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

describe 'rabbitmq_test::cook-2151' do
  include Helpers::RabbitMQ

  it 'includes the disk_free_limit configuration setting' do
    file("#{node['rabbitmq']['config_root']}/rabbitmq.config")
      .must_match(/\{disk_free_limit, \{mem_relative, #{node['rabbitmq']['disk_free_limit_relative']}/)
  end

  it 'includes the vm_memory_high_watermark configuration setting' do
    file("#{node['rabbitmq']['config_root']}/rabbitmq.config")
      .must_match(/\{vm_memory_high_watermark, #{node['rabbitmq']['vm_memory_high_watermark']}/)
  end

  it 'includes the open_file_limit configuration setting' do
    file("#{node['rabbitmq']['config_root']}/rabbitmq-env.conf")
      .must_match(/(ulimit -n #{node['rabbitmq']['open_file_limit']})/)
  end
end
