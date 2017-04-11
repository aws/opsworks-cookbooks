# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: resource_ssl_certificate_subject
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
      # ssl_certificate Chef Resource certificate subject related methods.
      module Subject
        # Resource subject attributes to be initialized by a
        # `default_#{attribute}` method.
        unless defined?(::Chef::Resource::SslCertificate::Subject::ATTRS)
          ATTRS = %w(
            common_name
            country
            city
            state
            organization
            department
            email
          )
        end

        def initialize_subject_defaults
          initialize_attribute_defaults(Subject::ATTRS)
        end

        def common_name(arg = nil)
          set_or_return(:common_name, arg, kind_of: String, required: true)
        end

        alias_method :domain, :common_name

        def country(arg = nil)
          set_or_return(:country, arg, kind_of: [String])
        end

        def city(arg = nil)
          set_or_return(:city, arg, kind_of: [String])
        end

        def state(arg = nil)
          set_or_return(:state, arg, kind_of: [String])
        end

        def organization(arg = nil)
          set_or_return(:organization, arg, kind_of: [String])
        end

        def department(arg = nil)
          set_or_return(:department, arg, kind_of: [String])
        end

        def email(arg = nil)
          set_or_return(:email, arg, kind_of: [String])
        end

        protected

        def default_common_name
          lazy { read_namespace('common_name') || node['fqdn'] }
        end

        def default_country
          lazy { read_namespace('country') }
        end

        def default_city
          lazy { read_namespace('city') }
        end

        def default_state
          lazy { read_namespace('state') }
        end

        def default_organization
          lazy { read_namespace('organization') }
        end

        def default_department
          lazy { read_namespace('department') }
        end

        def default_email
          lazy { read_namespace('email') }
        end

        def cert_subject
          Subject::ATTRS.each_with_object({}) do |field, mem|
            value = send(field)
            mem[field] = value if value.is_a?(String)
          end
        end
      end
    end
  end
end
