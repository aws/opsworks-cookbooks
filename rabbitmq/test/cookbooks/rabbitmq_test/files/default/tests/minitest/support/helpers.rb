#
# Copyright 2012-2013, Chef Software, Inc.
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

module Helpers
  # rabbitmq
  module RabbitMQ
    require 'mixlib/shellout'
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    def plugin_enabled?(plugin)
      plugins = Mixlib::ShellOut.new("rabbitmq-plugins list -e '#{plugin}'").run_command
      plugins.stdout =~ /(\[[Ee]\]\s#{plugin})/
    end

    def policy_enabled?(policy)
      policies = Mixlib::ShellOut.new('rabbitmqctl -q list_policies').run_command
      policies.stdout =~ /\t#{policy}\t/
    end

    def user_enabled?(user)
      users = Mixlib::ShellOut.new('rabbitmqctl -q list_users').run_command
      users.stdout =~ /(#{user}\s)/
    end

    def vhost_enabled?(vhost)
      vhosts = Mixlib::ShellOut.new('rabbitmqctl -q list_vhosts').run_command
      vhosts.stdout =~ /(\n#{vhost}\n)/
    end
  end
end
