# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: service_helpers
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2015 Onddo Labs, SL. (www.onddo.com)
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

# Chef configuration management tool main class.
class Chef
  # `ssl_certificate` cookbook specific classes with helpers.
  module SslCertificateCookbook
    # Helper methods to configure SSL Services specific parameters.
    #
    # These methods should be included using class `include` method.
    #
    # This library can be used to configure your service specific SSL options
    # like enabled cipher suites or allowed SSL protocols.
    #
    # The following example is used to generate the apache template:
    #
    # ```ruby
    # self.class.send(:include, Chef::SslCertificateCookbook::ServiceHelpers)
    # ssl_config = ssl_config_for_service('apache')
    # ```
    #
    # This will read the apache configuration from
    # `node['ssl_certificate']['service']['apache']` or
    # `node['ssl_certificate']['service'][compatibility]['apache']` and merge it
    # with the default configuraion.
    #
    # So you can use something like the following to integrate with your own
    # service (Postfix in this case):
    #
    # ```ruby
    # # attributes file
    # %w(old intermediate modern).each do |level|
    #   # Read protocols array.
    #   protos = node['ssl_certificate']['service'][level]['protocols']
    #   # Format the protocols list for Postfix
    #   default['ssl_certificate']['service'][level]['postfix']['protocols'] =
    #     protos.join(', ')
    # end
    # ```
    #
    # Then in your template:
    #
    # ```erb
    # <%
    # self.class.send(:include, Chef::SslCertificateCookbook::ServiceHelpers)
    # ssl_config = ssl_config_for_service('postfix')
    # -%>
    # # ...
    # smtpd_tls_mandatory_protocols = <%= ssl_config['protocols'] %>
    # ```
    module ServiceHelpers
      protected

      # @private
      def ssl_config_merge(hs1, hs2)
        Chef::Mixin::DeepMerge.hash_only_merge(hs1.dup, hs2.dup)
      end

      # @private
      def ssl_config_merge!(hs1, hs2)
        Chef::Mixin::DeepMerge.hash_only_merge!(hs1, hs2)
      end

      # @private
      def deprecated_config_merge
        node.default['ssl_certificate']['service'] = ssl_config_merge(
          node['ssl_certificate']['service'],
          node['ssl_certificate']['web']
        )
      end

      # @private
      def deprecated_config_check
        return if node['ssl_certificate']['web'].empty?
        Chef::Log.warn(
          '[DEPRECATED] Use '\
          "`node['ssl_certificate']['service']['compatibility']` instead of "\
          "`node['ssl_certificate']['web']['compatibility']`."
        )
        deprecated_config_merge
      end

      # @private
      def ssl_compatibility
        if @ssl_compatibility.is_a?(String) || @ssl_compatibility.is_a?(Symbol)
          @ssl_compatibility
        else
          node['ssl_certificate']['service']['compatibility']
        end
      end

      # @private
      def ssl_compatibility_set?
        (ssl_compatibility.is_a?(String) ||
          ssl_compatibility.is_a?(Symbol)) &&
          node['ssl_certificate']['service'][ssl_compatibility].is_a?(Hash)
      end

      # @private
      def ssl_config_default
        node['ssl_certificate']['service'].dup
      end

      # @private
      def ssl_config_compatibility
        unless ssl_compatibility_set? &&
               node['ssl_certificate']['service'][ssl_compatibility].is_a?(Hash)
          return Mash.new
        end
        node['ssl_certificate']['service'][ssl_compatibility]
      end

      # @private
      def ssl_config_service(ssl_config, service)
        return Mash.new unless ssl_config[service].is_a?(Hash)
        ssl_config.delete(service)
      end

      public

      # Returns the recommended SSL configuration.
      #
      # The returned hash has the following keys:
      #
      # * `'use_hsts'`: Whether to enable
      #   [HSTS](http://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security).
      # * `'use_stapling'`: Whether to enable
      #   [OCSP stapling](http://en.wikipedia.org/wiki/OCSP_stapling).
      # * `'description'`: Compatibility level description.
      # * `'cipher_suite'`: List of SSL ciphers as String.
      # * `'protocols'`: List of protocols as Array or merged String.
      #
      # @example
      #   default_ssl_config
      #   #=> {"use_hsts"=>true, "use_stapling"=>true,
      #   #    "description"=>"Modern compatibility: ...",
      #   #    "cipher_suite"=>"...", "protocols"=>["TLSv1.1", "TLSv1.2"]}
      # @api public
      def default_ssl_config
        deprecated_config_check
        config = ssl_config_default
        ssl_config_merge!(config, ssl_config_compatibility)
      end

      # Returns the recommended SSL configuration for a specific service.
      #
      # You can create your own service specific configurations creating
      # *service* subkeys under `node['ssl_certificate']['service']`.
      #
      # ```ruby
      # default['ssl_certificate']['service'][:modern]['postfix']['protocols'] =
      #   'TLSv1.1, TLSv1.2'
      # ```
      #
      # By default, comes with configurations for `'apache'` and `'nginx'`. Will
      # return default configuration for others ([#default_ssl_config]).
      #
      # @param service [String] service name.
      # @return [Hash] SSL specific configuration.
      # @example
      #   ssl_config_for_service('apache')
      #   #=> {"use_hsts"=>true, "use_stapling"=>true,
      #   #    "description"=>"Modern compatibility: ...",
      #   #    "cipher_suite"=>"...", "protocols"=>"all -SSLv2 -SSLv3 -TLSv1"}
      # @see #default_ssl_config
      # @api public
      def ssl_config_for_service(service)
        config = default_ssl_config
        config_service = ssl_config_service(config, service)
        ssl_config_merge!(config, config_service)
      end

      # Gets installed nginx version.
      #
      # @return [String] nginx version number.
      # @example
      #   nginx_version #=> '1.7.9'
      # @api public
      def nginx_version
        return nil unless node.key?('nginx')
        node['nginx']['version']
      end

      # Checks if installed nginx version satisfies a versions requirement.
      #
      # @param requirement [String] version requirement to check.
      # @return [Boolean] whether it meets the versions requirement.
      # @example
      #   nginx_version_satisfies?('>= 1.7') #=> true
      # @api public
      def nginx_version_satisfies?(requirement)
        return false if nginx_version.nil?
        version = Gem::Version.new(nginx_version)
        Gem::Requirement.new(requirement).satisfied_by?(version)
      end
    end
  end
end
