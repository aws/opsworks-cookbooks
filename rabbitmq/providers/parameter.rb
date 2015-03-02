#
# Cookbook Name:: rabbitmq
# Provider:: parameter
#
# Author: Sean Porter <portertech@gmail.com>
# Copyright 2015 by Heavy Water Operations, LLC.
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

def parameter_exists?(vhost, name)
  cmd = 'rabbitmqctl list_parameters'
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
  unless parameter_exists?(new_resource.vhost, new_resource.parameter)
    cmd = 'rabbitmqctl set_parameter'
    cmd << " -p #{new_resource.vhost}" unless new_resource.vhost.nil?
    cmd << " #{new_resource.component}"
    cmd << " #{new_resource.parameter}"

    cmd << " '"
    cmd << JSON.dump(new_resource.params)
    cmd << "'"

    parameter = "#{new_resource.component} #{new_resource.parameter}"

    execute "set_parameter #{parameter}" do
      command cmd
    end

    new_resource.updated_by_last_action(true)
    Chef::Log.info "Done setting RabbitMQ parameter #{parameter}."
  end
end

action :clear do
  if parameter_exists?(new_resource.vhost, new_resource.parameter)
    parameter = "#{new_resource.component} #{new_resource.parameter}"

    execute "clear_parameter #{parameter}" do
      command "rabbitmqctl clear_parameter #{parameter}"
    end

    new_resource.updated_by_last_action(true)
    Chef::Log.info "Done clearing RabbitMQ parameter #{parameter}."
  end
end

action :list do
  execute 'list_parameters' do
    command 'rabbitmqctl list_parameters'
  end

  new_resource.updated_by_last_action(true)
end
