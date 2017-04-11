#
# Author:: Joe Heung <joe.heung@logentries.com>
# Library:: follow_logs
#
# Copyright 2015 Logentries, Revelops Ireland Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module FollowLogs

  def follow_logs()
    node['le']['logs_to_follow'].each do |l|
      if l.instance_of? Chef::Node::ImmutableMash
        follow(l[:name], l[:log], l[:token])
      else
        follow(nil, l, nil)
      end
    end
  end

  # Script to follow a log
  def follow(name, path, token)
    cmd="le follow '#{path}'"

    if node['le']['pull-server-side-config']
      if name
        cmd +=" --name='#{name}'"
      end
      execute cmd do
        not_if "le followed '#{path}'"
        notifies :restart, 'service[logentries]'
      end
    else
      templ = "[#{name}]
path=#{path}"
      unless node['le']['datahub']['enable']
        templ += "\n"
        templ += "token=#{token}"
      end
      ruby_block 'append config' do
        not_if "grep '\\[#{name}\\]' /etc/le/config"
        block do
          file = Chef::Util::FileEdit.new('/etc/le/config')
          file.insert_line_if_no_match(/\[#{name}\]/, templ)
          file.write_file
        end
        notifies :restart, 'service[logentries]'
      end
    end
  end
end
