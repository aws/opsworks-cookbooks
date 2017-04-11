# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: resource_ssl_certificate_cert
# Author:: Raul Rodriguez (<raul@onddo.com>)
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

require 'chef/resource'
require 'openssl'

# Chef configuration management tool main class.
class Chef
  # Chef Resource describes the desired state of an element of your
  # infrastructure.
  class Resource
    class SslCertificate < Chef::Resource
      # ssl_certificate Chef Resource cert related methods.
      module Cert
        # Resource certificate attributes to be initialized by a
        # `default_#{attribute}` method.
        unless defined?(::Chef::Resource::SslCertificate::Cert::ATTRS)
          ATTRS = %w(
            cert_name
            cert_dir
            cert_path
            cert_source
            cert_bag
            cert_item
            cert_item_key
            cert_encrypted
            cert_secret_file
            cert_content
            subject_alternate_names
            ca_cert_path
            ca_key_path
          )
        end

        unless defined?(::Chef::Resource::SslCertificate::Cert::SOURCES)
          SOURCES = %w(
            attribute
            data_bag
            chef_vault
            file
            self_signed
            with_ca
          )
        end

        public

        def initialize_cert_defaults
          initialize_attribute_defaults(Cert::ATTRS)
        end

        def cert_name(arg = nil)
          set_or_return(:cert_name, arg, kind_of: String, required: true)
        end

        def cert_dir(arg = nil)
          set_or_return(:cert_dir, arg, kind_of: String)
        end

        def cert_path(arg = nil)
          set_or_return(:cert_path, arg, kind_of: String, required: true)
        end

        def cert_source(arg = nil)
          set_or_return(:cert_source, arg, kind_of: String)
        end

        def cert_bag(arg = nil)
          set_or_return(:cert_bag, arg, kind_of: String)
        end

        def cert_item(arg = nil)
          set_or_return(:cert_item, arg, kind_of: String)
        end

        def cert_item_key(arg = nil)
          set_or_return(:cert_item_key, arg, kind_of: String)
        end

        def cert_encrypted(arg = nil)
          set_or_return(:cert_encrypted, arg, kind_of: [TrueClass, FalseClass])
        end

        def cert_secret_file(arg = nil)
          set_or_return(:cert_secret_file, arg, kind_of: String)
        end

        def cert_content(arg = nil)
          set_or_return(:cert_content, arg, kind_of: String)
        end

        def subject_alternate_names(arg = nil)
          set_or_return(:subject_alternate_names, arg, kind_of: Array)
        end

        # CA cert public methods

        def ca_cert_path(arg = nil)
          set_or_return(:ca_cert_path, arg, kind_of: String)
        end

        def ca_key_path(arg = nil)
          set_or_return(:ca_key_path, arg, kind_of: String)
        end

        protected

        def default_cert_name
          "#{name}.pem"
        end

        def default_cert_dir
          node['ssl_certificate']['cert_dir']
        end

        def default_cert_path
          lazy_cached_variable(:default_cert_path) do
            read_namespace(%w(ssl_cert path)) ||
              ::File.join(cert_dir, cert_name)
          end
        end

        def default_cert_source
          lazy do
            read_namespace(%w(ssl_cert source)) || read_namespace('source') ||
              default_source
          end
        end

        def default_cert_bag
          lazy { read_namespace(%w(ssl_cert bag)) || read_namespace('bag') }
        end

        def default_cert_item
          lazy { read_namespace(%w(ssl_cert item)) || read_namespace('item') }
        end

        def default_cert_item_key
          lazy { read_namespace(%w(ssl_cert item_key)) }
        end

        def default_cert_encrypted
          lazy do
            read_namespace(%w(ssl_cert encrypted)) ||
              read_namespace('encrypted')
          end
        end

        def default_cert_secret_file
          lazy do
            read_namespace(%w(ssl_cert secret_file)) ||
              read_namespace('secret_file')
          end
        end

        def default_subject_alternate_names
          lazy { read_namespace(%w(ssl_cert subject_alternate_names)) }
        end

        def default_cert_content_from_attribute
          safe_read_namespace('SSL certificate', %w(ssl_cert content))
        end

        def default_cert_content_from_data_bag
          safe_read_from_data_bag(
            'SSL certificate',
            bag: cert_bag, item: cert_item, key: cert_item_key,
            encrypt: cert_encrypted, secret_file: cert_secret_file
          )
        end

        def default_cert_content_from_chef_vault
          safe_read_from_chef_vault(
            'SSL certificate',
            bag: cert_bag, item: cert_item, key: cert_item_key
          )
        end

        def default_cert_content_from_file
          safe_read_from_path('SSL certificate', cert_path)
        end

        def default_cert_content_from_self_signed
          content = read_from_path(cert_path)
          unless content.is_a?(String) &&
                 verify_self_signed_cert(
                   key_content, content, cert_subject, nil
                 )
            Chef::Log.debug("Generating new self-signed certificate: #{name}.")
            content = generate_cert(key_content, cert_subject, time)
            updated_by_last_action(true)
          end
          content
        end

        def read_ca_cert
          ca_cert_content = safe_read_from_path('CA certificate', ca_cert_path)
          ca_key_content = safe_read_from_path('CA key', ca_key_path)
          [ca_cert_content, ca_key_content]
        end

        def verify_self_signed_cert_with_ca(key_content, cert_content,
            cert_subject, ca_cert_content)
          cert_content.is_a?(String) &&
            verify_self_signed_cert(
              key_content, cert_content, cert_subject, ca_cert_content
            )
        end

        def generate_cert_with_ca(key_content, cert_subject, time,
            ca_cert_content, ca_key_content)
          Chef::Log.debug(
            "Generating new certificate: #{name} from the given CA."
          )
          content = generate_cert(
            key_content, cert_subject, time, ca_cert_content, ca_key_content
          )
          updated_by_last_action(true)
          content
        end

        def default_cert_content_from_with_ca
          content = read_from_path(cert_path)
          ca_cert_content, ca_key_content = read_ca_cert
          if content.is_a?(String) &&
             verify_self_signed_cert(key_content, content,
                                     cert_subject, ca_cert_content)
            return content
          end
          generate_cert_with_ca(
            key_content, cert_subject, time, ca_cert_content, ca_key_content
          )
        end

        def default_cert_content
          lazy_cached_variable(:default_cert_content) do
            source = filter_source(
              'SSL certificate', cert_source, Cert::SOURCES
            )
            send("default_cert_content_from_#{source}")
          end
        end

        # ca cert private methods

        def default_ca_cert_path
          lazy { read_namespace(%w(ca_cert_path)) }
        end

        def default_ca_key_path
          lazy { read_namespace(%w(ca_key_path)) }
        end
      end
    end
  end
end
