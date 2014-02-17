###
# Do not use this file to override the runit cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "runit/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'runit/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

#
# Cookbook Name:: runit
# Attribute File:: sv_bin
#
# Copyright 2008-2009, Opscode, Inc.
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

case node[:platform]
when 'ubuntu','debian'
  set[:runit][:sv_bin] = '/usr/bin/sv'
  set[:runit][:chpst_bin] = '/usr/bin/chpst'
  set[:runit][:service_dir] = '/etc/service'
  set[:runit][:sv_dir] = '/etc/sv'
when 'gentoo'
  set[:runit][:sv_bin] = '/usr/bin/sv'
  set[:runit][:chpst_bin] = '/usr/bin/chpst'
  set[:runit][:service_dir] = '/etc/service'
  set[:runit][:sv_dir] = '/var/service'
end

include_attribute "runit::customize"
