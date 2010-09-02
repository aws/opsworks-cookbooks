#
# Cookbook Name:: ruby_enterprise
# attributes:: ruby_enterprise
#
# Author:: Jonathan Weiss (<jonathan.weiss@peritor.com>)
# 
# Copyright:: 2010, Peritor GmbH
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

default[:ruby_enterprise][:version]                       = '2010.01'
default[:ruby_enterprise][:url]                           = {}
default[:ruby_enterprise][:url][:i386]                    = "http://peritor-assets.s3.amazonaws.com/ruby-enterprise_1.8.7-2010.01_i386.deb"
default[:ruby_enterprise][:url][:amd64]                   = "http://peritor-assets.s3.amazonaws.com/ruby-enterprise_1.8.7-2010.01_amd64.deb"
default[:ruby_enterprise][:gc]                            = {}
default[:ruby_enterprise][:gc][:heap_min_slots]           = 500000
default[:ruby_enterprise][:gc][:heap_slots_increment]     = 250000
default[:ruby_enterprise][:gc][:heap_slots_growth_factor] = 1
default[:ruby_enterprise][:gc][:malloc_limit]             = 50000000
default[:ruby_enterprise][:gc][:heap_free_min]            = 4096
default[:ruby_enterprise][:gems] = {}
default[:ruby_enterprise][:gems][:version] = '1.3.7'
default[:ruby_enterprise][:bundler] = {}
default[:ruby_enterprise][:bundler][:version] = '1.0.0'
