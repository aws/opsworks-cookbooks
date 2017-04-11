#
# Cookbook Name:: rabbitmq
# Provider:: policy
#
# Author: Robert Choi <taeilchoi1@gmail.com>
# Copyright 2013 by Robert Choi
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

require 'shellwords'

def policy_exists?(vhost, name)
  cmd = 'rabbitmqctl list_policies'
  cmd << " -p #{Shellwords.escape vhost}" unless vhost.nil?
  cmd << " |grep '#{name}\\b'"

  cmd = Mixlib::ShellOut.new(cmd)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  begin
    cmd.error!
    true
  rescue
    false
  end
end

action :set do
  unless policy_exists?(new_resource.vhost, new_resource.policy)
    cmd = 'rabbitmqctl set_policy'
    cmd << " -p #{new_resource.vhost}" unless new_resource.vhost.nil?
    cmd << " --apply-to #{new_resource.apply_to}" if new_resource.apply_to
    cmd << " #{new_resource.policy}"
    cmd << " \"#{new_resource.pattern}\""
    cmd << " '{"

    first_param = true
    new_resource.params.each do |key, value|
      cmd << ',' unless first_param

      if value.is_a? String
        cmd << "\"#{key}\":\"#{value}\""
      else
        cmd << "\"#{key}\":#{value}"
      end
      first_param = false
    end

    cmd << "}'"
    if node['rabbitmq']['version'] >= '3.2.0'
      cmd << " --priority #{new_resource.priority}" if new_resource.priority
    else
      cmd << " #{new_resource.priority}" if new_resource.priority
    end

    execute "set_policy #{new_resource.policy}" do
      command cmd
    end

    new_resource.updated_by_last_action(true)
    Chef::Log.info "Done setting RabbitMQ policy '#{new_resource.policy}'."
  end
end

action :clear do
  if policy_exists?(new_resource.vhost, new_resource.policy)
    execute "clear_policy #{new_resource.policy}" do
      command "rabbitmqctl clear_policy #{new_resource.policy}"
    end

    new_resource.updated_by_last_action(true)
    Chef::Log.info "Done clearing RabbitMQ policy '#{new_resource.policy}'."
  end
end

action :list do
  execute 'list_policies' do
    command 'rabbitmqctl list_policies'
  end

  new_resource.updated_by_last_action(true)
end
