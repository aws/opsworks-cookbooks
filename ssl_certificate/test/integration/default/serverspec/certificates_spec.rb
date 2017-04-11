# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014-2015 Onddo Labs, SL. (www.onddo.com)
# License:: Apache License, Version 2.0
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

require 'spec_helper'

family = os[:family].downcase
key_dir, cert_dir =
  if %w(debian ubuntu).include?(family)
    %w(/etc/ssl/private /etc/ssl/certs)
  elsif %w(redhat centos fedora scientific amazon).include?(family)
    %w(/etc/pki/tls/private /etc/pki/tls/certs)
  elsif %w(freebsd).include?(family)
    %w(/etc/ssl /etc/ssl)
  else
    %w(/etc /etc)
  end

web_user, web_group =
  if %w(debian ubuntu).include?(family)
    %w(www-data www-data)
  elsif %w(redhat centos fedora scientific amazon).include?(family)
    %w(apache apache)
  elsif %w(suse opensuse).include?(family)
    %w(wwwrun www)
  elsif %w(arch).include?(family)
    %w(http http)
  elsif %w(freebsd).include?(family)
    %w(www www)
  else
    %w(www-data www-data)
  end

group = family == 'freebsd' ? 'wheel' : 'root'

(1..4).each do |i|
  describe file("#{key_dir}/dummy#{i}.key") do
    it { should be_file }
    it { should be_mode 600 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
  end

  describe file("#{cert_dir}/dummy#{i}.pem") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
  end
end

describe file("#{key_dir}/dummy5-data-bag.key") do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by web_user }
  it { should be_grouped_into web_group }
end

describe file("#{cert_dir}/dummy5-data-bag.pem") do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by web_user }
  it { should be_grouped_into web_group }
end

describe file("#{key_dir}/dummy6-attributes.key") do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into group }
end

describe file("#{cert_dir}/dummy6-attributes.pem") do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into group }
end
