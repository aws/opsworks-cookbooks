#
# Cookbook Name:: rabbitmq
# Library:: default
# Author:: Jake Davis (<jake@simple.com>)
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

module Opscode
  # module rabbit
  module RabbitMQ
    # This method does some of the yuckiness of formatting parameters properly
    # for rendering into the rabbit.config template.
    def format_kernel_parameters  # rubocop:disable all
      rendered = []   # rubocop:enable all
      kernel = node['rabbitmq']['kernel'].dup

      # This parameter is special and needs commas instead of periods.
      rendered << "{inet_dist_use_interface, {#{kernel[:inet_dist_use_interface].gsub(/\./, ',')}}}" if kernel[:inet_dist_use_interface]
      kernel.delete(:inet_dist_use_interface)

      # Otherwise, we can just render it nicely as Erlang wants. This
      # theoretically opens the door for arbitrary kernel_app parameters to be
      # declared.
      kernel.select { |_k, v| !v.nil? }.each_pair do |param, val|
        rendered << "{#{param}, #{val}}"
      end

      rendered.each { |r| r.prepend('    ') }.join(",\n")
    end
  end
end
