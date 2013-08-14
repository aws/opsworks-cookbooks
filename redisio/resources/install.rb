#
# Cookbook Name:: redisio
# Resource::install
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
actions :run

#Uncomment this and remove the block in initialize when ready to drop support for chef <= 0.10.8
#default_action :run

#Installation attributes
attribute :version, :kind_of => String
attribute :download_url, :kind_of => String
attribute :download_dir, :kind_of => String, :default => Chef::Config[:file_cache_path]
attribute :artifact_type, :kind_of => String, :default => 'tar.gz'
attribute :base_name, :kind_of => String, :default => 'redis-'
attribute :safe_install, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :base_piddir, :kind_of => String, :default => '/var/run/redis'

#Configuration attributes
attribute :user, :kind_of => String, :default => 'redis'
attribute :group, :kind_of => String, :default => 'redis'

attribute :default_settings, :kind_of => Hash
attribute :servers, :kind_of => Array

def initialize(name, run_context=nil)
  super
  @action = :run
  @tarball = nil
end

