# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Resource:: ssl_certificate
# Author:: Raul Rodriguez (<raul@onddo.com>)
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Author:: Steve Meinel (<steve.meinel@caltech.edu>)
# Author:: Jeremy MAURO (<j.mauro@criteo.com>)
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
require_relative 'resource_ssl_certificate_subject'
require_relative 'resource_ssl_certificate_key'
require_relative 'resource_ssl_certificate_cert'
require_relative 'resource_ssl_certificate_keycert'
require_relative 'resource_ssl_certificate_chain'
require_relative 'resource_ssl_certificate_generators'
require_relative 'resource_ssl_certificate_readers'

# Chef configuration management tool main class.
class Chef
  # Chef Resource describes the desired state of an element of your
  # infrastructure.
  class Resource
    # ssl_certificate Chef Resource.
    class SslCertificate < Chef::Resource
      # Include methods related to certificate subject attributes.
      include ::Chef::Resource::SslCertificate::Subject
      # Include methods related to key attributes.
      include ::Chef::Resource::SslCertificate::Key
      # Include methods related to cert attributes.
      include ::Chef::Resource::SslCertificate::Cert
      # Include methods related to key and cert (common) attributes.
      include ::Chef::Resource::SslCertificate::KeyCert
      # Include methods related to intermediary chain certs attributes.
      include ::Chef::Resource::SslCertificate::Chain
      # Include methods related to certification generation.
      include ::Chef::Resource::SslCertificate::Generators
      # Include helper methods to read from differente sources.
      include ::Chef::Resource::SslCertificate::Readers

      def initialize(name, run_context = nil)
        super
        @resource_name = :ssl_certificate
        @action = :create
        @allowed_actions.push(@action)
        @provider = Chef::Provider::SslCertificate
        @namespace = Mash.new
        initialize_defaults
      end

      public

      def initialize_attribute_defaults(attributes)
        attributes.each do |var|
          instance_variable_set("@#{var}".to_sym, send("default_#{var}"))
        end
      end

      def depends_chef_vault?
        key_source == 'chef-vault' || cert_source == 'chef-vault'
      end

      # used by load_current_resource
      def load
        key = read_from_path(key_path)
        key_content(key) unless key.nil?
        cert = read_from_path(cert_path)
        cert_content(cert) unless cert.nil?
        chain = read_from_path(chain_path) unless chain_path.nil?
        chain_content(chain) unless chain.nil?
      end

      def exist?
        # chain_content is optional
        @key_content.is_a?(String) && @cert_content.is_a?(String) &&
          (@chain_content.is_a?(String) || @chain_content.nil?)
      end

      def ==(other)
        other.is_a?(self.class) &&
          key_eql?(other) && cert_eql?(other) && name_eql?(other)
      end

      alias_method :===,  :==

      def namespace(arg = nil)
        unless arg.nil? || arg.is_a?(Chef::Node) ||
               arg.is_a?(Chef::Node::ImmutableMash)
          arg = read_node_namespace(arg)
        end
        set_or_return(
          :namespace, arg,
          kind_of: [Chef::Node, Chef::Node::ImmutableMash, Mash]
        )
      end

      def time(arg = nil)
        # ~ 10 years
        set_or_return(
          :time, arg, kind_of: [Fixnum, String, Time], default: 315_360_000
        )
      end

      def owner(arg = nil)
        set_or_return(
          :owner, arg,
          kind_of: String, default: node['ssl_certificate']['user']
        )
      end

      def group(arg = nil)
        set_or_return(
          :group, arg,
          kind_of: String, default: node['ssl_certificate']['group']
        )
      end

      private

      def initialize_defaults
        initialize_key_defaults
        initialize_cert_defaults
        initialize_chain_defaults
        initialize_subject_defaults
      end

      def key_eql?(other)
        key_path == other.key_path &&
          key_content == other.key_content
      end

      def cert_eql?(other)
        cert_path == other.cert_path &&
          cert_content == other.cert_content
      end

      def name_eql?(other)
        common_name == other.common_name
      end

      def lazy_cached_variable(var, &block)
        lazy do
          value = instance_variable_get("@#{var}")
          if value.nil?
            value = instance_eval(&block)
            instance_variable_set("@#{var}", value)
          else
            value
          end
        end
      end
    end
  end
end
