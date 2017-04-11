# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: resource_ssl_certificate_key
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

# Chef configuration management tool main class.
class Chef
  # Chef Resource describes the desired state of an element of your
  # infrastructure.
  class Resource
    class SslCertificate < Chef::Resource
      # ssl_certificate Chef Resource key related methods.
      module Key
        # Resource key attributes to be initialized by a `default_#{attribute}`
        # method.
        unless defined?(::Chef::Resource::SslCertificate::Key::ATTRS)
          ATTRS = %w(
            key_name
            key_dir
            key_path
            key_source
            key_bag
            key_item
            key_item_key
            key_encrypted
            key_secret_file
            key_content
          )
        end

        unless defined?(::Chef::Resource::SslCertificate::Key::SOURCES)
          SOURCES = %w(
            attribute
            data_bag
            chef_vault
            file
            self_signed
          )
        end

        public

        def initialize_key_defaults
          initialize_attribute_defaults(Key::ATTRS)
        end

        def key_name(arg = nil)
          set_or_return(:key_name, arg, kind_of: String, required: true)
        end

        def key_dir(arg = nil)
          set_or_return(:key_dir, arg, kind_of: String)
        end

        def key_path(arg = nil)
          set_or_return(:key_path, arg, kind_of: String, required: true)
        end

        def key_source(arg = nil)
          set_or_return(:key_source, arg, kind_of: String)
        end

        def key_bag(arg = nil)
          set_or_return(:key_bag, arg, kind_of: String)
        end

        def key_item(arg = nil)
          set_or_return(:key_item, arg, kind_of: String)
        end

        def key_item_key(arg = nil)
          set_or_return(:key_item_key, arg, kind_of: String)
        end

        def key_encrypted(arg = nil)
          set_or_return(:key_encrypted, arg, kind_of: [TrueClass, FalseClass])
        end

        def key_secret_file(arg = nil)
          set_or_return(:key_secret_file, arg, kind_of: String)
        end

        def key_content(arg = nil)
          set_or_return(:key_content, arg, kind_of: String)
        end

        protected

        def default_key_name
          "#{name}.key"
        end

        def default_key_dir
          node['ssl_certificate']['key_dir']
        end

        def default_key_path
          lazy_cached_variable(:default_key_path) do
            read_namespace(%w(ssl_key path)) || ::File.join(key_dir, key_name)
          end
        end

        def default_key_source
          lazy do
            read_namespace(%w(ssl_key source)) || read_namespace('source') ||
              default_source
          end
        end

        def default_key_bag
          lazy { read_namespace(%w(ssl_key bag)) || read_namespace('bag') }
        end

        def default_key_item
          lazy { read_namespace(%w(ssl_key item)) || read_namespace('item') }
        end

        def default_key_item_key
          lazy { read_namespace(%w(ssl_key item_key)) }
        end

        def default_key_encrypted
          lazy do
            read_namespace(%w(ssl_key encrypted)) || read_namespace('encrypted')
          end
        end

        def default_key_secret_file
          lazy do
            read_namespace(%w(ssl_key secret_file)) ||
              read_namespace('secret_file')
          end
        end

        def default_key_content_from_attribute
          safe_read_namespace('SSL key', %w(ssl_key content))
        end

        def default_key_content_from_data_bag
          safe_read_from_data_bag(
            'SSL key',
            bag: key_bag, item: key_item, key: key_item_key,
            encrypt: key_encrypted, secret_file: key_secret_file
          )
        end

        def default_key_content_from_chef_vault
          safe_read_from_chef_vault(
            'SSL key',
            bag: key_bag, item: key_item, key: key_item_key
          )
        end

        def default_key_content_from_file
          safe_read_from_path('SSL key', key_path)
        end

        def default_key_content_from_self_signed
          content = read_from_path(key_path)
          unless content.is_a?(String)
            content = generate_key
            updated_by_last_action(true)
          end
          content
        end

        def default_key_content
          lazy_cached_variable(:default_key_content) do
            source = filter_source('SSL key', key_source, Key::SOURCES)
            send("default_key_content_from_#{source}")
          end
        end
      end
    end
  end
end
