# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: resource_ssl_certificate_keycert
# Author:: Raul Rodriguez (<raul@onddo.com>)
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
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

require 'chef/resource'
require 'openssl'

# Chef configuration management tool main class.
class Chef
  # Chef Resource describes the desired state of an element of your
  # infrastructure.
  class Resource
    class SslCertificate < Chef::Resource
      # ssl_certificate Chef Resource key and cert common related methods.
      module KeyCert
        def years(arg = nil)
          return (time.to_i / 31_536_000).round if arg.nil?
          unless [Fixnum, String].inject(false) { |a, e| a || arg.is_a?(e) }
            fail Exceptions::ValidationFailed,
                 "Option years must be a kind of #{to_be}! You passed "\
                 "#{arg.inspect}."
          end
          time(arg.to_i * 31_536_000)
        end

        def dir(arg = nil)
          return key_dir if arg.nil?
          key_dir(arg)
          cert_dir(arg)
          chain_dir(arg)
        end

        def source(arg = nil)
          return key_source if arg.nil?
          key_source(arg)
          cert_source(arg)
          chain_source(arg)
        end

        def bag(arg = nil)
          return key_bag if arg.nil?
          key_bag(arg)
          cert_bag(arg)
          chain_bag(arg)
        end

        def item(arg = nil)
          return key_item if arg.nil?
          key_item(arg)
          cert_item(arg)
          chain_item(arg)
        end

        def encrypted(arg = nil)
          return key_encrypted if arg.nil?
          key_encrypted(arg)
          cert_encrypted(arg)
          chain_encrypted(arg)
        end

        def secret_file(arg = nil)
          return key_secret_file if arg.nil?
          key_secret_file(arg)
          cert_secret_file(arg)
          chain_secret_file(arg)
        end

        protected

        def default_source
          'self-signed'
        end

        def assert_source!(desc, source, valid_sources)
          return if valid_sources.include?(source)
          fail "Cannot read #{desc}, unknown source: #{source}"
        end

        def filter_source(desc, source, valid_sources)
          source = source.gsub('-', '_')
          assert_source!(desc, source, valid_sources)
          source
        end
      end
    end
  end
end
