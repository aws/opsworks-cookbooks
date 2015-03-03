#
# Author:: Sean OMeara (<someara@getchef.com>)
# Recipe:: yum-erlang_solutions::default
#
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

yum_repository 'erlang_solutions' do
  description node['yum']['erlang_solutions']['description']
  baseurl node['yum']['erlang_solutions']['baseurl']
  mirrorlist node['yum']['erlang_solutions']['mirrorlist']
  gpgcheck node['yum']['erlang_solutions']['gpgcheck']
  gpgkey node['yum']['erlang_solutions']['gpgkey']
  enabled node['yum']['erlang_solutions']['enabled']
  cost node['yum']['erlang_solutions']['cost']
  exclude node['yum']['erlang_solutions']['exclude']
  enablegroups node['yum']['erlang_solutions']['enablegroups']
  failovermethod node['yum']['erlang_solutions']['failovermethod']
  http_caching node['yum']['erlang_solutions']['http_caching']
  include_config node['yum']['erlang_solutions']['include_config']
  includepkgs node['yum']['erlang_solutions']['includepkgs']
  keepalive node['yum']['erlang_solutions']['keepalive']
  max_retries node['yum']['erlang_solutions']['max_retries']
  metadata_expire node['yum']['erlang_solutions']['metadata_expire']
  mirror_expire node['yum']['erlang_solutions']['mirror_expire']
  priority node['yum']['erlang_solutions']['priority']
  proxy node['yum']['erlang_solutions']['proxy']
  proxy_username node['yum']['erlang_solutions']['proxy_username']
  proxy_password node['yum']['erlang_solutions']['proxy_password']
  repositoryid node['yum']['erlang_solutions']['repositoryid']
  sslcacert node['yum']['erlang_solutions']['sslcacert']
  sslclientcert node['yum']['erlang_solutions']['sslclientcert']
  sslclientkey node['yum']['erlang_solutions']['sslclientkey']
  sslverify node['yum']['erlang_solutions']['sslverify']
  timeout node['yum']['erlang_solutions']['timeout']
  action :create
end
