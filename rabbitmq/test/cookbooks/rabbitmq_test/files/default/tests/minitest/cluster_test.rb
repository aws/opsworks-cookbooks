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

describe 'rabbitmq_test::cluster' do
  it 'writes the erlang cookie file' do
    file('/var/lib/rabbitmq/.erlang.cookie').must_exist
  end

  it 'writes cluster configuration to the config file' do
    file('/etc/rabbitmq/rabbitmq.conf').must_match(
      /^    {cluster_nodes, [.*]},$/
    )
  end
end
