#
# Cookbook Name:: erlang
# Recipe:: esl
#
# Author:: Christopher Maier (<cm@chef.io>)
# Copyright 2013, Chef Software, Inc.
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

# Install Erlang/OTP from Erlang Solutions

case node['platform_family']
when 'debian'

  include_recipe 'apt'

  apt_repository 'erlang_solutions_repo' do
    uri 'http://packages.erlang-solutions.com/debian/'
    distribution node['erlang']['esl']['lsb_codename']
    components ['contrib']
    key 'http://packages.erlang-solutions.com/debian/erlang_solutions.asc'
    action :add
  end

  package 'esl-erlang' do
    version node['erlang']['esl']['version'] if node['erlang']['esl']['version']
  end

when 'rhel'
  if node['platform_version'].to_i <= 5
    Chef::Log.fatal('Erlang Solutions pacakge repositories are not available for EL5')
  else
    # include_recipe 'yum-repoforge'
    include_recipe 'yum-erlang_solutions'
  end

  package 'erlang' do
    version node['erlang']['esl']['version'] if node['erlang']['esl']['version']
  end

end

# There's a small bug in the package for Ubuntu 10.04... this fixes
# it.  Solution found at
# https://github.com/davidcoallier/bigcouch/blob/f6a6daf7590ecbab4d9dc4747624573b3137dfad/README.md#ubuntu-1004-lts-potential-issues
if platform?('ubuntu') && node['platform_version'] == '10.04'
  bash 'ubuntu-10.04-LTS-erlang-fix' do
    user 'root'
    cwd '/usr/lib/erlang/man/man5'
    code <<-EOS
      rm modprobe.d.5
      ln -s modprobe.conf.5.gz modprobe.d.5
    EOS
  end
end
