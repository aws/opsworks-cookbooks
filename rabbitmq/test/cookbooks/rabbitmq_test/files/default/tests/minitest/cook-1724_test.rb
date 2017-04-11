#
# Copyright 2012, Chef Software, Inc. <legal@chef.io>
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

describe 'rabbitmq_test::cook-1724' do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  it 'doesnt use the rabbitmq apt repository' do
    skip 'Only applicable on Debian family' unless node['platform_family'] == 'debian'

    file('/etc/apt/sources.list.d/rabbitmq-source.list').wont_exist &&
      package('rabbitmq-server').must_be_installed
  end
end
