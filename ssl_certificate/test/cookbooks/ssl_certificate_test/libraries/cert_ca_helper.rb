# encoding: UTF-8
#
# Cookbook Name:: ssl_certificate_test
# Library:: cert_ca_helper
# Description:: Library to create Certificate Authority.
# Author:: Jeremy MAURO (<j.mauro@criteo.com>)
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

# Helper module to create Certificate Authority certificates.
module CACertificate
  require 'openssl'
  extend ::Chef::Resource::SslCertificate::Generators

  unless defined?(CACertificate::EXTENSIONS)
    EXTENSIONS = [
      %w(subjectKeyIdentifier hash),
      ['basicConstraints', 'CA:TRUE', true],
      ['keyUsage', 'cRLSign,keyCertSign', true]
    ]
  end

  def self.key_with_pass_phrase(key, pass_phrase)
    cipher = OpenSSL::Cipher::Cipher.new('AES-128-CBC')

    open(key_file, 'w', 0400) do |io|
      io.write key.export(cipher, pass_phrase)
    end
  end

  def self.key_to_file(key_file, pass_phrase = nil)
    key = OpenSSL::PKey::RSA.new(2048)
    if pass_phrase
      key_with_pass_phrase(key, pass_phrase)
    else
      open(key_file, 'w', 0400) do |io|
        io.write key.to_pem
      end
    end
  end

  def self.generate_ca_cert_extensions(cert)
    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = cert
    ef.issuer_certificate = cert
    cert_add_extensions(cert, ef, CACertificate::EXTENSIONS)
    ef
  end

  def self.generate_self_signed_ca_cert(key, cert, subject)
    cert.public_key = key.public_key
    cert.subject = generate_cert_subject(subject)
    cert.issuer = cert.subject
    _ef = generate_ca_cert_extensions(cert)
    cert
  end

  def self.ca_cert_to_file(subject, key_file, cert_file, time)
    key = File.read(key_file)
    key, cert = generate_generic_x509_key_cert(key, time)

    generate_self_signed_ca_cert(key, cert, subject)

    cert.sign(key, OpenSSL::Digest::SHA1.new)
    open(cert_file, 'w') { |io| io.write cert.to_pem }
  end
end
