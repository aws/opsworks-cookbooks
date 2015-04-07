# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate
# Library:: resource_ssl_certificate_generation
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
      # ssl_certificate Chef Resource cert generator helpers.
      module Generators
        def generate_key
          OpenSSL::PKey::RSA.new(2048).to_pem
        end

        unless defined?(::Chef::Resource::SslCertificate::Generators::FIELDS)
          FIELDS = {
            country: {
              field: 'C',
              type: OpenSSL::ASN1::PRINTABLESTRING
            },
            state: {
              field: 'ST',
              type: OpenSSL::ASN1::PRINTABLESTRING
            },
            city: {
              field: 'L',
              type: OpenSSL::ASN1::PRINTABLESTRING
            },
            organization: {
              field: 'O',
              type: OpenSSL::ASN1::UTF8STRING
            },
            department: {
              field: 'OU',
              type: OpenSSL::ASN1::UTF8STRING
            },
            common_name: {
              field: 'CN',
              type: OpenSSL::ASN1::UTF8STRING
            },
            email: {
              field: 'emailAddress',
              type: OpenSSL::ASN1::UTF8STRING
            }
          }
        end

        unless defined?(::Chef::Resource::SslCertificate::Generators::
               EXTENSIONS)
          EXTENSIONS = {
            without_ca: [
              ['basicConstraints', 'CA:TRUE', true],
              ['subjectKeyIdentifier', 'hash', false],
              ['authorityKeyIdentifier', 'keyid:always,issuer:always', false]
            ],
            with_ca: [
              %w(basicConstraints CA:FALSE),
              %w(subjectKeyIdentifier hash),
              %w(keyUsage keyEncipherment,dataEncipherment,digitalSignature)
            ]
          }
        end

        def generate_cert_subject_from_string(s)
          [['CN', s.to_s, OpenSSL::ASN1::UTF8STRING]]
        end

        def generate_cert_subject_from_hash(s)
          Generators::FIELDS.each_with_object([]) do |(name, info), mem|
            name = name.to_s
            field = info[:field]
            type = info[:type]
            mem.push([field, s[name].to_s, type]) unless s[name].nil?
          end
        end

        def generate_cert_subject(s)
          name =
            if s.is_a?(Hash)
              generate_cert_subject_from_hash(s)
            else
              generate_cert_subject_from_string(s)
            end
          OpenSSL::X509::Name.new(name)
        end

        def generate_csr(key, subject)
          csr = OpenSSL::X509::Request.new
          csr.version = 0
          csr.subject = generate_cert_subject(subject)
          csr.public_key = key.public_key
          csr.sign(key, OpenSSL::Digest::SHA1.new)
          csr
        end

        def generate_generic_x509_key_cert(key, time)
          key = OpenSSL::PKey::RSA.new(key)
          cert = OpenSSL::X509::Certificate.new
          cert.version = 2
          cert.serial = OpenSSL::BN.rand(160)
          cert.not_before = Time.now
          cert.not_after =
            time.is_a?(Time) ? time : cert.not_before + time.to_i
          [key, cert]
        end

        def cert_add_extensions(cert, ef, extensions)
          extensions.each do |ext|
            cert.add_extension(ef.create_extension(*ext))
          end
        end

        def generate_self_signed_cert_with_extensions(cert, issuer_cert, exts)
          ef = OpenSSL::X509::ExtensionFactory.new
          ef.subject_certificate = cert
          ef.issuer_certificate = issuer_cert
          cert_add_extensions(cert, ef, exts)
          ef
        end

        def generate_self_signed_cert_without_ca_extensions(cert)
          generate_self_signed_cert_with_extensions(
            cert, cert, Generators::EXTENSIONS[:without_ca]
          )
        end

        def generate_self_signed_cert_without_ca(key, cert, subject)
          cert.subject = generate_cert_subject(subject)
          cert.issuer = cert.subject # self-signed
          cert.public_key = key.public_key

          ef = generate_self_signed_cert_without_ca_extensions(cert)
          if subject_alternate_names
            handle_subject_alternative_names(cert, ef, subject_alternate_names)
          end
          cert.sign(key, OpenSSL::Digest::SHA256.new)
        end

        def generate_ca_from_content(cert_content, key_content)
          ca_cert = OpenSSL::X509::Certificate.new(cert_content)
          ca_key = OpenSSL::PKey::RSA.new(key_content)
          [ca_cert, ca_key]
        end

        def generate_self_signed_cert_with_ca_extensions(cert, ca_cert)
          generate_self_signed_cert_with_extensions(
            cert, ca_cert, Generators::EXTENSIONS[:with_ca]
          )
        end

        def generate_self_signed_cert_with_ca_csr(cert, key, ca_cert, subject)
          csr = generate_csr(key, subject)
          cert.subject = csr.subject
          cert.public_key = csr.public_key
          cert.issuer = ca_cert.subject
        end

        def generate_self_signed_cert_with_ca(key, cert, subject, ca_cert_cont,
            ca_key_cont)
          ca_cert, ca_key = generate_ca_from_content(ca_cert_cont, ca_key_cont)

          generate_self_signed_cert_with_ca_csr(cert, key, ca_cert, subject)
          ef = generate_self_signed_cert_with_ca_extensions(cert, ca_cert)

          if subject_alternate_names
            handle_subject_alternative_names(cert, ef, subject_alternate_names)
          end
          cert.sign(ca_key, OpenSSL::Digest::SHA256.new)
        end

        # Based on https://gist.github.com/nickyp/886884
        def generate_cert(key, subject, time, ca_cert_content = nil,
            ca_key_content = nil)
          key, cert = generate_generic_x509_key_cert(key, time)
          if ca_cert_content && ca_key_content
            generate_self_signed_cert_with_ca(
              key, cert, subject, ca_cert_content, ca_key_content
            ).to_pem
          else
            generate_self_signed_cert_without_ca(key, cert, subject).to_pem
          end
        end

        # Subject Alternative Names support taken and modified from
        # https://github.com/cchandler/certificate_authority/blob/master/lib
        # /certificate_authority/signing_request.rb
        def handle_subject_alternative_names(cert, factory, alt_names)
          fail 'alt_names must be an Array' unless alt_names.is_a?(Array)

          name_list = alt_names.map { |m| "DNS:#{m}" }.join(',')
          ext = factory.create_ext('subjectAltName', name_list, false)
          cert.add_extension(ext)
        end

        def load_current_subjects(cert)
          cur = cert.subject
          new = generate_cert_subject(cert_subject)
          [cur, new]
        end

        def log_debug_subjects(cur, new)
          Chef::Log.debug("SSL certificate current subject: #{cur}")
          Chef::Log.debug("SSL certificate new subject: #{new}")
        end

        def compare_self_signed_cert_with_ca(_key, cert, ca_cert_content)
          cur_subject, new_subject = load_current_subjects(cert)

          log_debug_subjects(cur_subject, new_subject)
          ca_cert = OpenSSL::X509::Certificate.new(ca_cert_content)
          cur_subject.cmp(new_subject) == 0 &&
            cert.issuer.cmp(ca_cert.subject) && cert.verify(ca_cert.public_key)
        end

        def compare_self_signed_cert_without_ca(key, cert)
          cur_subject, new_subject = load_current_subjects(cert)

          log_debug_subjects(cur_subject, new_subject)
          key.params['n'] == cert.public_key.params['n'] &&
            cur_subject.cmp(new_subject) == 0 &&
            cert.issuer.cmp(cur_subject) == 0
        end

        def verify_self_signed_cert(key, cert, _hostname, ca_cert_content = nil)
          key = OpenSSL::PKey::RSA.new(key)
          cert = OpenSSL::X509::Certificate.new(cert)
          if ca_cert_content
            compare_self_signed_cert_with_ca(key, cert, ca_cert_content)
          else
            compare_self_signed_cert_without_ca(key, cert)
          end
        end
      end
    end
  end
end
