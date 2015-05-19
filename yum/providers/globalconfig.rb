#
# Cookbook Name:: yum
# Provider:: repository
#
# Author:: Sean OMeara <someara@chef.io>
# Copyright 2013, Chef
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

# Allow for Chef 10 support
use_inline_resources if defined?(use_inline_resources)

action :create  do
  template new_resource.path do
    source 'main.erb'
    cookbook 'yum'
    mode '0644'
    variables(:config => new_resource)
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end
