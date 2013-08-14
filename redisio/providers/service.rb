#
# Cookbook Name:: redisio
# Provider::service
#
# Copyright 2013, Brian Bianco <brian.bianco@gmail.com>
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

action :start do
  Chef::Log.warn("The redisio_service resource is deprecated!  Please use the redis<port> resource instead!")
  case node.platform
  when 'ubuntu','debian','centos','redhat','fedora', 'amazon'
    if ::File.exists?("/etc/init.d/redis#{new_resource.server_port}")
      execute "/etc/init.d/redis#{new_resource.server_port} start"
    else
      Chef::Log.warn("Cannot start service, init script not found")
    end
  end
end

action :stop do
  Chef::Log.warn("The redisio_service resource is deprecated!  Please use the redis<port> resource instead!")
  case node.platform
  when 'ubuntu','debian','centos','redhat','fedora', 'amazon'
    if ::File.exists?("/etc/init.d/redis#{new_resource.server_port}")
      execute "/etc/init.d/redis#{new_resource.server_port} stop"
    else
      Chef::Log.warn("Cannot stop service, init script not found")
    end
  end
end

action :restart do
  Chef::Log.warn("The redisio_service resource is deprecated!  Please use the redis<port> resource instead!")
  case node.platform
  when 'ubuntu','debian','centos','redhat','fedora', 'amazon'
    if ::File.exists?("/etc/init.d/redis#{new_resource.server_port}")
      execute "/etc/init.d/redis#{new_resource.server_port} stop && /etc/init.d/redis#{new_resource.server_port} start"
    else
      Chef::Log.warn("Cannot restart service, init script does not exist")
    end
  end
end

action :enable do
  Chef::Log.warn("The redisio_service resource is deprecated!  Please use the redis<port> resource instead!")
  case node.platform
  when 'ubuntu','debian'
    if ::File.exists?("/etc/init.d/redis#{new_resource.server_port}")
      execute "update-rc.d redis#{new_resource.server_port} start 91 2 3 4 5 . stop 91 0 1 6 ."
    else
      Chef::Log.warn("Cannot enable service, init script does not exist")
    end
  when 'redhat','centos','fedora','scientific','amazon','suse'
    if ::File.exists?("/etc/init.d/redis#{new_resource.server_port}")
      execute "chkconfig --add redis#{new_resource.server_port} && chkconfig --level 2345 redis#{new_resource.server_port} on"
    else
      Chef::Log.warn("Cannot enable service, init script does not exist")
    end
  end
end

action :disable do
  Chef::Log.warn("The redisio_service resource is deprecated!  Please use the redis<port> resource instead!")
  case node.platform
  when 'ubuntu','debian'
    if ::File.exists?("/etc/init.d/redis#{new_resource.server_port}")
      execute "update-rc.d -f redis#{new_resource.server_port} remove"
    else
      Chef::Log.warn("Cannot disable service, init script does not exist")
    end

  when 'redhat','centos','fedora','scientific','amazon','suse'
    if ::File.exists?("/etc/init.d/redis#{new_resource.server_port}")
      execute "chkconfig --level 2345 redis#{new_resource.server_port} off && chkconfig --del redis#{new_resource.server_port}"
    else
      Chef::Log.warn("Cannot disable service, init script does not exist")
    end
  end

end
