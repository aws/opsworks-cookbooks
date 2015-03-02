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

describe 'rabbitmq_test::cook-1684' do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  it 'installs rabbitmq from deb file when apt isnt used' do
    skip 'Only applicable on Debian family' unless node['platform_family'] == 'debian'

    file("#{Chef::Config[:file_cache_path]}/rabbitmq-server_#{node['rabbitmq']['version']}-1_all.deb").must_exist &&
      package('rabbitmq-server').must_be_installed
  end

  it 'installs rabbitmq from yum when used' do
    skip 'Only applicable on RHEL/Fedora family' unless node['platform_family'] == 'rhel' || node['platform_family'] == 'fedora'

    rpm_path = "#{Chef::Config[:file_cache_path]}/rabbitmq-server-#{node['rabbitmq']['version']}-1.noarch.rpm"

    file(rpm_path).wont_exist && package('rabbitmq-server').must_be_installed
  end
end
