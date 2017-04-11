#
# Cookbook Name:: rabbitmq
# Provider:: plugin
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

def plugin_enabled?(name)
  cmdstr = "rabbitmq-plugins list -e '#{name}\\b'"
  cmd = Mixlib::ShellOut.new(cmdstr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "rabbitmq_plugin_enabled?: #{cmdstr}"
  Chef::Log.debug "rabbitmq_plugin_enabled?: #{cmd.stdout}"
  cmd.error!
  cmd.stdout =~ /\b#{name}\b/
end

use_inline_resources

action :enable do
  unless plugin_enabled?(new_resource.plugin)
    execute "rabbitmq-plugins enable #{new_resource.plugin}" do
      Chef::Log.info "Enabling RabbitMQ plugin '#{new_resource.plugin}'."
      environment 'PATH' => "#{ENV['PATH']}:/usr/lib/rabbitmq/bin"
      new_resource.updated_by_last_action(true)
    end
  end
end

action :disable do
  if plugin_enabled?(new_resource.plugin)
    execute "rabbitmq-plugins disable #{new_resource.plugin}" do
      Chef::Log.info "Disabling RabbitMQ plugin '#{new_resource.plugin}'."
      environment 'PATH' => "#{ENV['PATH']}:/usr/lib/rabbitmq/bin"
      new_resource.updated_by_last_action(true)
    end
  end
end
