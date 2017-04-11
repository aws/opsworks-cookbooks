#
# Cookbook Name:: rabbitmq
# Resource:: policy
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

actions :set, :clear, :list
default_action :set

attribute :policy, :kind_of => String, :name_attribute => true
attribute :pattern, :kind_of => String
attribute :params, :kind_of => Hash
attribute :priority, :kind_of => Integer
attribute :vhost, :kind_of => String
attribute :apply_to, :kind_of => String, :equal_to => %w(all queues exchanges)
