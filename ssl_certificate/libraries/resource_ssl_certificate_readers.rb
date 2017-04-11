# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: resource_ssl_certificate_readers
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
    # ssl_certificate Chef Resource.
    class SslCertificate < Chef::Resource
      # ssl_certificate Chef Resource methods to read from differente sources.
      module Readers
        protected

        def unsafe_no_exceptions_block(&block)
          instance_eval(&block)
        rescue StandardError => e
          Chef::Log.error(e.message)
          Chef::Log.error("Backtrace:\n#{e.backtrace.join("\n")}\n")
          nil
        end

        def read_namespace_from_object(obj, ary)
          ary = [ary].flatten
          # TODO: Check ary parameter value.
          ary.inject(obj) do |n, k|
            n.respond_to?(:key?) && n.key?(k) ? n[k] : nil
          end
        end

        def read_namespace(ary)
          read_namespace_from_object(namespace, ary)
        end

        def read_node_namespace(ary)
          read_namespace_from_object(node, ary)
        end

        # Read some values from node namespace avoiding exceptions.
        def safe_read_namespace(desc, ary)
          data = read_namespace(ary)
          unless data.is_a?(String)
            fail "Cannot read #{desc} from node attributes"
          end
          data
        end

        def read_from_path(path)
          return nil unless ::File.exist?(path)
          ::IO.read(path)
        end

        def safe_read_from_path(desc, path)
          data = read_from_path(path)
          unless data.is_a?(String)
            fail "Cannot read #{desc} from path: #{path}"
          end
          data
        end

        def data_bag_read_fail(desc, db, type = 'data bag')
          fail "Cannot read #{desc} from #{type}: "\
            "#{db[:bag]}.#{db[:item]}[#{db[:key]}]"
        end

        def read_from_data_bag(bag, item, key, encrypt = false, secret = nil)
          unsafe_no_exceptions_block do
            data =
              if encrypt
                Chef::EncryptedDataBagItem.load(bag, item, secret)
              else
                Chef::DataBagItem.load(bag, item)
              end
            data[key.to_s]
          end
        end

        def safe_read_from_data_bag(desc, db)
          data = read_from_data_bag(
            db[:bag], db[:item], db[:key], db[:encrypt], db[:secret_file]
          )
          data_bag_read_fail(desc, db) unless data.is_a?(String)
          data
        end

        def read_from_chef_vault(bag, item, key)
          require 'chef-vault'
          unsafe_no_exceptions_block do
            data = ChefVault::Item.load(bag, item)
            data[key.to_s]
          end
        end

        def safe_read_from_chef_vault(desc, db)
          data = read_from_chef_vault(db[:bag], db[:item], db[:key])
          data_bag_read_fail(desc, db, 'chef-vault') unless data.is_a?(String)
          data
        end
      end
    end
  end
end
