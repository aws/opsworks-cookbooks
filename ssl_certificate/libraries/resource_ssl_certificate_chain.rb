# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: resource_ssl_certificate_chain
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
      module Chain
        # Resource certificate attributes to be initialized by a
        # `default_#{attribute}` method.
        unless defined?(::Chef::Resource::SslCertificate::Chain::ATTRS)
          ATTRS = %w(
            chain_path
            chain_name
            chain_dir
            chain_source
            chain_bag
            chain_item
            chain_item_key
            chain_encrypted
            chain_secret_file
            chain_content
            chain_combined_path
            chain_combined_name
          )
        end

        unless defined?(::Chef::Resource::SslCertificate::Chain::SOURCES)
          SOURCES = %w(
            attribute
            data_bag
            chef_vault
            file
          )
        end

        public

        def initialize_chain_defaults
          initialize_attribute_defaults(Chain::ATTRS)
        end

        def chain_name(arg = nil)
          set_or_return(:chain_name, arg, kind_of: String, required: false)
        end

        def chain_dir(arg = nil)
          set_or_return(:chain_dir, arg, kind_of: String)
        end

        def chain_path(arg = nil)
          set_or_return(:chain_path, arg, kind_of: String, required: false)
        end

        def chain_source(arg = nil)
          set_or_return(:chain_source, arg, kind_of: String)
        end

        def chain_bag(arg = nil)
          set_or_return(:chain_bag, arg, kind_of: String)
        end

        def chain_item(arg = nil)
          set_or_return(:chain_item, arg, kind_of: String)
        end

        def chain_item_key(arg = nil)
          set_or_return(:chain_item_key, arg, kind_of: String)
        end

        def chain_encrypted(arg = nil)
          set_or_return(:chain_encrypted, arg, kind_of: [TrueClass, FalseClass])
        end

        def chain_secret_file(arg = nil)
          set_or_return(:chain_secret_file, arg, kind_of: String)
        end

        def chain_content(arg = nil)
          set_or_return(:chain_content, arg, kind_of: String)
        end

        def chain_combined_name(arg = nil)
          set_or_return(
            :chain_combined_name, arg, kind_of: String, required: false
          )
        end

        def chain_combined_path(arg = nil)
          set_or_return(
            :chain_combined_path, arg, kind_of: String, required: false
          )
        end

        protected

        # chain private methods

        def default_chain_path
          lazy_cached_variable(:default_chain_path) do
            if chain_name.is_a?(String)
              read_namespace(%w(ssl_chain path)) ||
                ::File.join(chain_dir, chain_name)
            end
          end
        end

        def default_chain_name
          lazy { read_namespace(%w(ssl_chain name)) }
        end

        def default_chain_dir
          node['ssl_certificate']['cert_dir']
        end

        def default_chain_source
          lazy do
            read_namespace(%w(ssl_chain source)) || read_namespace('source') ||
              default_source
          end
        end

        def default_chain_bag
          lazy { read_namespace(%w(ssl_chain bag)) || read_namespace('bag') }
        end

        def default_chain_item
          lazy { read_namespace(%w(ssl_chain item)) || read_namespace('item') }
        end

        def default_chain_item_key
          lazy { read_namespace(%w(ssl_chain item_key)) }
        end

        def default_chain_encrypted
          lazy do
            read_namespace(%w(ssl_chain encrypted)) ||
              read_namespace('encrypted')
          end
        end

        def default_chain_secret_file
          lazy do
            read_namespace(%w(ssl_chain secret_file)) ||
              read_namespace('secret_file')
          end
        end

        def default_chain_content_from_attribute
          safe_read_namespace('SSL ntermediary chain', %w(ssl_chain content))
        end

        def default_chain_content_from_data_bag
          safe_read_from_data_bag(
            'SSL intermediary chain',
            bag: chain_bag, item: chain_item, key: chain_item_key,
            encrypt: chain_encrypted, secret_file: chain_secret_file
          )
        end

        def default_chain_content_from_chef_vault
          safe_read_from_chef_vault(
            'SSL intermediary chain',
            bag: chain_bag, item: chain_item, key: chain_item_key
          )
        end

        def default_chain_content_from_file
          safe_read_from_path('SSL intermediary chain', chain_path)
        end

        def default_chain_content
          lazy_cached_variable(:default_chain_content) do
            source = filter_source(
              'SSL intermediary chain', chain_source, Chain::SOURCES
            )
            send("default_chain_content_from_#{source}")
          end
        end

        def default_chain_combined_path
          lazy do
            @default_chain_combined_path ||=
              ::File.join(cert_dir, chain_combined_name)
          end
        end

        def default_chain_combined_name
          lazy { "#{cert_name}.chained.pem" }
        end
      end
    end
  end
end
