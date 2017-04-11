Description
===========
[![Cookbook Version](https://img.shields.io/cookbook/v/ssl_certificate.svg?style=flat)](https://supermarket.getchef.com/cookbooks/ssl_certificate)
[![Dependency Status](http://img.shields.io/gemnasium/onddo/ssl_certificate-cookbook.svg?style=flat)](https://gemnasium.com/onddo/ssl_certificate-cookbook)
[![Code Climate](http://img.shields.io/codeclimate/github/onddo/ssl_certificate-cookbook.svg?style=flat)](https://codeclimate.com/github/onddo/ssl_certificate-cookbook)
[![Build Status](http://img.shields.io/travis/onddo/ssl_certificate-cookbook.svg?style=flat)](https://travis-ci.org/onddo/ssl_certificate-cookbook)

The main purpose of this cookbook is to make it easy for other cookbooks to support SSL. With the resource included, you will be able to manage certificates reading them from attributes, data bags or chef-vaults. Exposing its configuration through node attributes.

Much of the code in this cookbook is heavily based on the SSL implementation from the [owncloud](http://community.opscode.com/cookbooks/owncloud) cookbook.

Table of Contents
=================

* [Requirements](#requirements)
  * [Supported Platforms](#supported-platforms)
  * [Required Applications](#required-applications)
* [Attributes](#attributes)
  * [Service Attributes](#service-attributes)
* [Resources](#resources)
  * [ssl_certificate](#ssl_certificate)
    * [ssl_certificate Actions](#ssl_certificate-actions)
    * [ssl_certificate Parameters](#ssl_certificate-parameters)
* [Templates](#templates)
  * [Partial Templates](#partial-templates)
  * [Securing Server Side TLS](#securing-server-side-tls)
* [Usage](#usage)
  * [Including the Cookbook](#including-the-cookbook)
  * [A Short Example](#a-short-example)
  * [Namespaces](#namespaces)
  * [Examples](#examples)
    * [Apache Examples](#apache-examples)
    * [Nginx Example](#nginx-example)
    * [Reading the Certificate from Attributes](#reading-the-certificate-from-attributes)
    * [Reading the Certificate from a Data Bag](#reading-the-certificate-from-a-data-bag)
    * [Reading the Certificate from Chef Vault](#reading-the-certificate-from-chef-vault)
    * [Reading the Certificate from Files](#reading-the-certificate-from-files)
    * [Reading the Certificate from Different Places](#reading-the-certificate-from-different-places)
    * [Creating a Certificate with Subject Alternate Names](#creating-a-certificate-with-subject-alternate-names)
    * [Reading Key, Certificate and Intermediary from a Data Bag](#reading-key-certificate-and-intermediary-from-a-data-bag)
    * [Creating a Certificate from a Certificate Authority](#creating-a-certificate-from-a-certificate-authority)
    * [Reading the CA Certificate from a Chef Vault Bag](#reading-the-ca-certificate-from-a-chef-vault-bag)
    * [Managing Certificates Via Attributes](#managing-certificates-via-attributes)
* [Testing](#testing)
  * [ChefSpec Matchers](#chefspec-matchers)
    * [ssl_certificate(name)](#ssl_certificatename)
    * [create_ssl_certificate(name)](#create_ssl_certificatename)
* [Contributing](#contributing)
* [TODO](#todo)
* [License and Author](#license-and-author)

Requirements
============

## Supported Platforms

This cookbook has been tested on the following platforms:

* Amazon Linux
* CentOS
* Debian
* Fedora
* FreeBSD
* RedHat
* Ubuntu

Please, [let us know](https://github.com/onddo/ssl_certificate-cookbook/issues/new?title=I%20have%20used%20it%20successfully%20on%20...) if you use it successfully on any other platform.

## Required Applications

* Chef `>= 11.14.2`.
* Ruby `1.9.3` or higher.

Attributes
==========

| Attribute                                             | Default      | Description                        |
|:------------------------------------------------------|:-------------|:-----------------------------------|
| `node['ssl_certificate']['user']`                     | `'root'`     | Default SSL files owner user.
| `node['ssl_certificate']['group']`                    | *calculated* | Default SSL files owner group.
| `node['ssl_certificate']['key_dir']`                  | *calculated* | Default SSL key directory.
| `node['ssl_certificate']['cert_dir']`                 | *calculated* | Default SSL certificate directory.

## Service Attributes

The following attributes are used to integrate SSL specific configurations with different services (Apache, nginx, ...). They are used internally by [the apache and nginx templates](#templates).

| Attribute                                             | Default      | Description                        |
|:------------------------------------------------------|:-------------|:-----------------------------------|
| `node['ssl_certificate']['service']['cipher_suite']`  | `nil`        | Service default SSL cipher suite.
| `node['ssl_certificate']['service']['protocols']`     | `nil`        | Service default SSL protocols.
| `node['ssl_certificate']['service']['apache']`        | *calculated* | Apache web service httpd specific SSL attributes.
| `node['ssl_certificate']['service']['nginx']`         | *calculated* | nginx web service specific SSL attributes.
| `node['ssl_certificate']['service']['compatibility']` | `nil`        | Service SSL compatibility level (See [below](#securing-server-side-tls)).
| `node['ssl_certificate']['service']['use_hsts']`      | `true`       | Whether to enable [HSTS](http://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security) in the service.
| `node['ssl_certificate']['service']['use_stapling']`  | *calculated* | Whether to enable [OCSP stapling](http://en.wikipedia.org/wiki/OCSP_stapling) in the service (nginx only, use `node['apache']['mod_ssl']['use_stapling']` for apache).

See the [`ServiceHelpers` class documentation](http://www.rubydoc.info/github/onddo/ssl_certificate-cookbook/master/Chef/SslCertificateCookbook/ServiceHelpers) to learn how to integrate them with new services.

Resources
=========

## ssl_certificate

Creates a SSL certificate.

By default the resource will create a self-signed certificate, but a custom one can also be used. The custom certificate can be read from several sources:

* Attribute
* Data Bag
* Encrypted Data Bag
* Chef Vault
* File

### ssl_certificate Actions

* `create`: Creates the SSL certificate.

### ssl_certificate Parameters

<table>
  <tr>
    <th>Parameter</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>namespace</td>
    <td>Node namespace to read the default values from, something like <code>node['myapp']</code>. See the documentation below for more information on how to use the namespace.</td>
    <td><code>{}</code></td>
  </tr>
  <tr>
    <td>common_name</td>
    <td>Server name or <em>Common Name</em>, used for self-signed certificates.</td>
    <td><code>namespace['common_name']</code></td>
  </tr>
  <tr>
    <td>domain</td>
    <td><code>common_name</code> method alias.</td>
    <td><code>namespace['common_name']</code></td>
  </tr>
  <tr>
    <td>country</td>
    <td><em>Country</em>, used for self-signed certificates.</td>
    <td><code>namespace['country']</code></td>
  </tr>
  <tr>
    <td>city</td>
    <td><em>City</em>, used for self-signed certificates.</td>
    <td><code>namespace['city']</code></td>
  </tr>
  <tr>
    <td>state</td>
    <td><em>State</em> or <em>Province</em> name, used for self-signed certificates.</td>
    <td><code>namespace['state']</code></td>
  </tr>
  <tr>
    <td>organization</td>
    <td><em>Organization</em> or <em>Company</em> name, used for self-signed certificates.</td>
    <td><code>namespace['city']</code></td>
  </tr>
  <tr>
    <td>department</td>
    <td>Department or <em>Organizational Unit</em>, used for self-signed certificates.</td>
    <td><code>namespace['city']</code></td>
  </tr>
  <tr>
    <td>email</td>
    <td><em>Email</em> address, used for self-signed certificates.</td>
    <td><code>namespace['email']</code></td>
  </tr>
  <tr>
    <td>time</td>
    <td>Attribute for setting self-signed certificate validity time in seconds or <code>Time</code> object instance.</td>
    <td><code>10 * 365 * 24 * 60 * 60</code></td>
  </tr>
  <tr>
    <td>years</td>
    <td>Write only attribute for setting self-signed certificate validity period in years.</td>
    <td><code>10</code></td>
  </tr>
  <tr>
    <td>owner</td>
    <td>Certificate files owner user.</td>
    <td><code>node['ssl_certificate']['user']</code></td>
  </tr>
  <tr>
    <td>group</td>
    <td>Certificate files owner group.</td>
    <td><code>node['ssl_certificate']['group']</code></td>
  </tr>
  <tr>
    <td>dir</td>
    <td>Write only attribute for setting certificate path and key path (both) to a directory (<code>key_dir</code> and <code>cert_dir</code>).</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>source</td>
    <td>Write only attribute for setting certificate source and key source (both) to a value (<code>key_source</code> and <code>cert_source</code>). Can be <code>'self-signed'</code>, <code>'attribute'</code>, <code>'data-bag'</code>, <code>'chef-vault'</code> or <code>'file'</code>.</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>bag</td>
    <td>Write only attribute for setting certificate bag and key bag (both) to a value (<code>key_bag</code> and <code>cert_bag</code>).</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>item</td>
    <td>Write only attribute for setting certificate item name and key bag item name (both) to a value (<code>key_item</code> and <code>cert_item</code>).</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>encrypted</td>
    <td>Write only attribute for setting certificate encryption and key encryption (both) to a value (<code>key_encrypted</code> and <code>cert_encrypted</code>).</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>secret_file</td>
    <td>Write only attribute for setting certificate chef secret file and key chef secret file (both) to a value (<code>key_secret_file</code> and <code>cert_secret_file</code>).</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>key_path</td>
    <td>Private key full path.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>key_name</td>
    <td>Private key file name.</td>
    <td><code>"#{name}.key"</code></td>
  </tr>
  <tr>
    <td>key_dir</td>
    <td>Private key directory path.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>key_source</td>
    <td>Source type to get the SSL key from. Can be <code>'self-signed'</code>, <code>'attribute'</code>, <code>'data-bag'</code>, <code>'chef-vault'</code> or <code>'file'</code>.</td>
    <td><code>'self-signed'</code></td>
  </tr>
  <tr>
    <td>key_bag</td>
    <td>Name of the Data Bag where the SSL key is stored.</td>
    <td><code>namespace['ssl_key']['bag']</code></td>
  </tr>
  <tr>
    <td>key_item</td>
    <td>Name of the Data Bag Item where the SSL key is stored.</td>
    <td><code>namespace['ssl_key']['item']</code></td>
  </tr>
  <tr>
    <td>key_item_key</td>
    <td>Key of the Data Bag Item where the SSL key is stored.</td>
    <td><code>namespace['ssl_key']['item_key']</code></td>
  </tr>
  <tr>
    <td>key_encrypted</td>
    <td>Whether the Data Bag where the SSL key is stored is encrypted.</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td>key_secret_file</td>
    <td>Secret file used to decrypt the Data Bag where the SSL key is stored.</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>key_content</td>
    <td>SSL key file content in clear. <strong>Be careful when using it.<strong></td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>cert_path</td>
    <td>Public certificate full path.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>cert_name</td>
    <td>Public certiticate file name.</td>
    <td><code>"#{name}.pem"</code></td>
  </tr>
  <tr>
    <td>cert_dir</td>
    <td>Public certificate directory path.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>cert_source</td>
    <td>Source type to get the SSL cert from. Can be <code>'self-signed'</code>,
    <code>'with_ca'</code>, <code>'attribute'</code>, <code>'data-bag'</code>,
    <code>'chef-vault'</code> or <code>'file'</code>.</td>
    <td><code>'self-signed'</code></td>
  </tr>
  <tr>
    <td>cert_bag</td>
    <td>Name of the Data Bag where the SSL cert is stored.</td>
    <td><code>namespace['ssl_cert']['bag']</code></td>
  </tr>
  <tr>
    <td>cert_item</td>
    <td>Name of the Data Bag Item where the SSL cert is stored.</td>
    <td><code>namespace['ssl_cert']['item']</code></td>
  </tr>
  <tr>
    <td>cert_item_key</td>
    <td>Key of the Data Bag Item where the SSL cert is stored.</td>
    <td><code>namespace['ssl_cert']['item_key']</code></td>
  </tr>
  <tr>
    <td>cert_encrypted</td>
    <td>Whether the Data Bag where the SSL cert is stored is encrypted.</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td>cert_secret_file</td>
    <td>Secret file used to decrypt the Data Bag where the SSL cert is stored.</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>cert_content</td>
    <td>SSL cert file content in clear.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>subject_alternate_names</td>
    <td>Subject Alternate Names for the cert.</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>chain_path</td>
    <td>Intermediate certificate chain full path.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>chain_name</td>
    <td>File name of intermediate certificate chain file.</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>chain_dir</td>
    <td>Intermediate certificate chain directory path.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>chain_source</td>
    <td>Source type to get the intermediate certificate chain from. Can be <code>'attribute'</code>, <code>'data-bag'</code>, <code>'chef-vault'</code> or <code>'file'</code>.</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>chain_bag</td>
    <td>Name of the Data Bag where the intermediate certificate chain is stored.</td>
    <td><code>namespace['ssl_chain']['bag']</code></td>
  </tr>
  <tr>
    <td>chain_item</td>
    <td>Name of the Data Bag Item where the intermediate certificate chain is stored.</td>
    <td><code>namespace['ssl_chain']['item']</code></td>
  </tr>
  <tr>
    <td>chain_item_key</td>
    <td>Key of the Data Bag Item where the intermediate certificate chain is stored.</td>
    <td><code>namespace['ssl_chain']['item_key']</code></td>
  </tr>
  <tr>
    <td>chain_encrypted</td>
    <td>Whether the Data Bag where the intermediate certificate chain is stored is encrypted.</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td>chain_secret_file</td>
    <td>Secret file used to decrypt the Data Bag where the intermediate certificate chain is stored.</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td>chain_content</td>
    <td>Intermediate certificate chain file content in clear.</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>chain_combined_name</td>
    <td>File name of intermediate certificate chain combined file (for <strong>nginx</strong>).</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>chain_combined_path</td>
    <td>Intermediate certificate chain combined file full path (for <strong>nginx</strong>).</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td>ca_cert_path</td>
    <td>Certificate Authority full path.</td>
    <td><em>nil</em></td>
  </tr>
  <tr>
    <td>ca_key_path</td>
    <td>Key Authority full path.</td>
    <td><em>nil</em></td>
  </tr>
</table>

Templates
=========

This cookbook includes a simple VirtualHost template which can be used by the `web_app` definition from the [apache2](http://community.opscode.com/cookbooks/apache2) cookbook:

```ruby
cert = ssl_certificate 'my-webapp' do
  namespace node['my-webapp']
  notifies :restart, 'service[apache2]'
end

include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'
web_app 'my-webapp' do
  cookbook 'ssl_certificate'
  server_name cert.common_name
  docroot # [...]
  # [...]
  ssl_key cert.key_path
  ssl_cert cert.cert_path
  ssl_chain cert.chain_path
end
```

## Partial Templates

This cookbook contains [partial templates](http://docs.chef.io/templates.html#partial-templates) that you can include in your virtualhost templates to enable and configure the SSL protocol. These partial templates are available:

* *apache.erb*: For Apache httpd web server.
* *nginx.erb*: For nginx web server.

### Partial Templates Parameters

| Parameter          | Default          | Description                        |
|:-------------------|:-----------------|:-----------------------------------|
| ssl_cert           | `nil`            | Public SSL certificate full path.
| ssl_key            | `nil`            | Private SSL key full path.
| ssl_chain          | `nil`            | Intermediate SSL certificate chain full path (**apache** only) *(optional)*.
| ssl_compatibility  | *node attribute* | SSL compatibility level (See [below](#securing-server-side-tls)).

### Apache Partial Template

#### Using `web_app` Definition

If you are using the `web_app` definition, you should pass the `@params` variables to the partial template:

```ruby
web_app 'my-webapp-ssl' do
  docroot node['apache']['docroot_dir']
  server_name cert.common_name
  # [...]
  ssl_key cert.key_path
  ssl_cert cert.cert_path
  ssl_chain cert.chain_path
end
```

```erb
<%# included by web_app definition %>
<VirtualHost *:443>
  ServerName <%= @params[:server_name] %>
  DocumentRoot <%= @params[:docroot] %>
  <%# [...] %>

  <%= render 'apache.erb', cookbook: 'ssl_certificate', variables: @params.merge(node: node) %>
</VirtualHost>
```

#### Using `template` Resource

```ruby
cert = ssl_certificate 'my-webapp-ssl'
template File.join(node['apache']['dir'], 'sites-available', 'my-webapp-ssl') do
  source 'apache_vhost.erb'
  # [...]
  variables(
    # [...]
    ssl_key: cert.key_path,
    ssl_cert: cert.chain_combined_path,
    ssl_chain: cert.chain_path
  )
end
```

You can include the partial template as follows:

```erb
<%# included by template resource %>
<VirtualHost *:443>
  ServerName <%= @server_name %>
  DocumentRoot <%= @docroot %>
  <%# [...] %>

  <%= render 'apache.erb', cookbook: 'ssl_certificate' %>
</VirtualHost>
```

### Nginx Partial Template

If you are using nginx template, we recommended to use the `SslCertificate#chain_combined_path` path value to set the `ssl_cert` variable instead of `SslCertificate#cert_path`. That's to ensure we [always include the chained certificate](http://nginx.org/en/docs/http/configuring_https_servers.html#chains) if there is one. This will also work when there is no chained certificate.

```ruby
cert = ssl_certificate 'my-webapp-ssl'
template File.join(node['nginx']['dir'], 'sites-available', 'my-webapp-ssl') do
  source 'nginx_vhost.erb'
  # [...]
  variables(
    # [...]
    ssl_key: cert.key_path,
    ssl_cert: cert.chain_combined_path
  )
end
```

See [examples below](#examples).

## Securing Server Side TLS

You can change the SSL compatibility level based on [the TLS recommendations in the Mozilla wiki](https://wiki.mozilla.org/Security/Server_Side_TLS#Recommended_configurations) using the `ssl_compatibility` template parameter:

```ruby
cert = ssl_certificate 'my-webapp' do
  namespace node['my-webapp']
  notifies :restart, 'service[apache2]'
end

include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'
web_app 'my-webapp' do
  cookbook 'ssl_certificate'
  server_name cert.common_name
  docroot # [...]
  # [...]
  ssl_key cert.key_path
  ssl_cert cert.cert_path
  ssl_chain cert.chain_path
  ssl_compatibility :modern # :modern | :intermediate | :old
end
```

You can also use the `node['ssl_certificate']['service']['compatibility']` node attribute to change the compatibility level used by default.

Usage
=====

## Including the Cookbook

You need to include this recipe in your `run_list` before using the  `ssl_certificate` resource:

```json
{
  "name": "onddo.com",
  "[...]": "[...]",
  "run_list": [
    "recipe[ssl_certificate]"
  ]
}
```

You can also include the cookbook as a dependency in the metadata of your cookbook:

```ruby
# metadata.rb
depends 'ssl_certificate'
```

One of the two is enough. No need to do anything else. Only use the `ssl_certificate` resource to create the certificates you need.

## A Short Example

```ruby
cert = ssl_certificate 'webapp1' do
  namespace node['webapp1'] # optional but recommended
end
# you can now use the #cert_path and #key_path methods to use in your
# web/mail/ftp service configurations
log "WebApp1 certificate is here: #{cert.cert_path}"
log "WebApp1 private key is here: #{cert.key_path}"
```

## Namespaces

The `ssl_certificate` **namespace** attribute is a node attribute path, like for example `node['onddo.com']`, used to configure SSL certificate defaults. This will make easier to *integrate the node attributes* with the certificate creation matters. This means you can configure the certificate creation through node attributes.

When a namespace is set in the resource, it will try to read the following attributes below the namespace (all attributes are **optional**):

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><code>namespace['common_name']</code></td>
    <td>Server name or *Common Name*, used for self-signed certificates (uses <code>node['fqdn']</code> by default).</td>
  </tr>
  <tr>
    <td><code>namespace['country']</code></td>
    <td><em>Country</em>, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace['city']</code></td>
    <td><em>City</em>, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace['state']</code></td>
    <td><em>State</em> or <em>Province</em> name, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace['organization']</code></td>
    <td><em>Organization</em> or <em>Company</em> name, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace['department']</code></td>
    <td>Department or <em>Organizational Unit</em>, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace['email']</code></td>
    <td><em>Email</em> address, used for self-signed certificates.</td>
  </tr>
  <tr>
    <td><code>namespace['source']</code></td>
    <td>Attribute for setting certificate source and key source (both) to a value (<code>key_source</code> and <code>cert_source</code>).</td>
  </tr>
  <tr>
    <td><code>namespace['bag']</code></td>
    <td>Attribute for setting certificate bag and key bag (both) to a value (<code>key_bag</code> and <code>cert_bag</code>).</td>
  </tr>
  <tr>
    <td><code>namespace['item']</code></td>
    <td>Attribute for setting certificate item name and key bag item name (both) to a value (<code>key_item</code> and <code>cert_item</code>).</td>
  </tr>
  <tr>
    <td><code>namespace['encrypted']</code></td>
    <td>Attribute for setting certificate encryption and key encryption (both) to a value (<code>key_encryption</code> and <code>cert_encryption</code>).</td>
  </tr>
  <tr>
    <td><code>namespace['secret_file']</code></td>
    <td>Attribute for setting certificate chef secret file and key chef secret file (both) to a value (<code>key_secret_file</code> and <code>cert_secret_file</code>).</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_key']['source']</code></td>
    <td>Source type to get the SSL key from. Can be <code>'self-signed'</code>, <code>'attribute'</code>, <code>'data-bag'</code>, <code>'chef-vault'</code> or <code>'file'</code>.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_key']['path']</code></td>
    <td>File path of the SSL key.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_key']['bag']</code></td>
    <td>Name of the Data Bag where the SSL key is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_key']['item']</code></td>
    <td>Name of the Data Bag Item where the SSL key is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_key']['item_key']</code></td>
    <td>Key of the Data Bag Item where the SSL key is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_key']['encrypted']</code></td>
    <td>Whether the Data Bag where the SSL key is stored is encrypted.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_key']['secret_file']</code></td>
    <td>Secret file used to decrypt the Data Bag where the SSL key is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_key']['content']</code></td>
    <td>SSL key content used when reading from attributes.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_cert']['source']</code></td>
    <td>Source type to get the SSL cert from. Can be <code>'self-signed'</code>, <code>'attribute'</code>, <code>'data-bag'</code>, <code>'chef-vault'</code> or <code>'file'</code>.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_cert']['path']</code></td>
    <td>File path of the SSL certificate.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_cert']['bag']</code></td>
    <td>Name of the Data Bag where the SSL cert is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_cert']['item']</code></td>
    <td>Name of the Data Bag Item where the SSL cert is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_cert']['item_key']</code></td>
    <td>Key of the Data Bag Item where the SSL cert is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_cert']['encrypted']</code></td>
    <td>Whether the Data Bag where the SSL cert is stored is encrypted.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_cert']['secret_file']</code></td>
    <td>Secret file used to decrypt the Data Bag where the SSL cert is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_cert']['content']</code></td>
    <td>SSL cert content used when reading from attributes.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_cert']['subject_alternate_names']</code></td>
    <td>An array of Subject Alternate Names for the SSL cert. Needed if your site has multiple domain names on the same cert.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_chain']['name']</code></td>
    <td>File name to be used for the intermediate certificate chain file. <em>If this is not present, no chain file will be written.</em></td>
  </tr>
  <tr>
    <td><code>namespace['ssl_chain']['source']</code></td>
    <td>Source type to get the intermediate certificate chain from. Can be <code>'attribute'</code>, <code>'data-bag'</code>, <code>'chef-vault'</code> or <code>'file'</code>.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_chain']['path']</code></td>
    <td>File path of the intermediate SSL certificate chain.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_chain']['bag']</code></td>
    <td>Name of the Data Bag where the intermediate certificate chain is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_chain']['item']</code></td>
    <td>Name of the Data Bag Item where the intermediate certificate chain is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_chain']['item_key']</code></td>
    <td>Key of the Data Bag Item where the intermediate certificate chain is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_chain']['encrypted']</code></td>
    <td>Whether the Data Bag where the intermediate certificate chain is stored is encrypted.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_chain']['secret_file']</code></td>
    <td>Secret file used to decrypt the Data Bag where the intermediate certificate chain is stored.</td>
  </tr>
  <tr>
    <td><code>namespace['ssl_chain']['content']</code></td>
    <td>Intermediate certificate chain content used when reading from attributes.</td>
  </tr>
</table>

## Examples

### Apache Examples

Apache `web_app` example using community [apache2](http://community.opscode.com/cookbooks/apache2) cookbook and node attributes:

```ruby
node.default['my-webapp']['common_name'] = 'onddo.com'
node.default['my-webapp']['ssl_cert']['source'] = 'self-signed'
node.default['my-webapp']['ssl_key']['source'] = 'self-signed'

# we need to save the resource variable to get the key and certificate file
# paths
cert = ssl_certificate 'my-webapp' do
  # we want to be able to use node['my-webapp'] to configure the certificate
  namespace node['my-webapp']
  notifies :restart, 'service[apache2]'
end

include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'
web_app 'my-webapp' do
  # this cookbook includes a virtualhost template for apache2
  cookbook 'ssl_certificate'
  server_name cert.common_name
  docroot # [...]
  # [...]
  ssl_key cert.key_path
  ssl_cert cert.cert_path
  ssl_chain cert.chain_path
end
```

Using custom paths:

```ruby
my_key_path = '/etc/keys/my-webapp.key'
my_cert_path = '/etc/certs/my-webapp.pem'

# there is no need to save the resource in a variable in this case because we
# know the paths
ssl_certificate 'my-webapp' do
  key_path my_key_path
  cert_path my_cert_path
end

# Configure Apache SSL
include_recipe 'apache2::mod_ssl'
web_app 'my-webapp' do
  cookbook 'ssl_certificate'
  # [...]
  ssl_key my_key_path
  ssl_cert my_cert_path
end
```

See [templates documentation](#templates).

### Nginx Example

Minimal `nginx` example using community [nginx](http://community.opscode.com/cookbooks/nginx) cookbook:

```ruby
cert = ssl_certificate 'my-webapp' do
  notifies :restart, 'service[nginx]'
end

# Create a virtualhost for nginx
template File.join(node['nginx']['dir'], 'sites-available', 'my-webapp-ssl') do
  # You need to create a template for nginx to enable SSL support and read the
  # keys from ssl_key and ssl_chain_combined attributes.
  # You can use the *nginx.erb* partial template as shown below.
  source 'nginx_vhost.erb'
  mode 00644
  owner 'root'
  group 'root'
  variables(
    name: 'my-webapp-ssl',
    server_name: 'ssl.onddo.com',
    docroot: '/var/www',
    # [...]
    ssl_key: cert.key_path,
    ssl_cert: cert.chain_combined_path
  )
  notifies :reload, 'service[nginx]'
end

# Enable the virtualhost
nginx_site 'my-webapp-ssl' do
  enable true
end

# publish the certificate to an attribute, it may be useful
node.set['web-app']['ssl_cert']['content'] = cert.cert_content
```

Here's a nginx template example using the [*nginx.erb* partial template](#partial-templates):

```erb
<%# nginx_vhost.erb %>
server {
  server_name <%= @server_name %>;
  listen 443;
  # Path to the root of your installation
  root <%= @docroot %>;

  access_log <%= node['nginx']['log_dir'] %>/<%= @name %>-access.log combined;
  error_log  <%= node['nginx']['log_dir'] %>/<%= @name %>-error.log;

  index index.html;
  <%# [...] %>

  <%= render 'nginx.erb', cookbook: 'ssl_certificate' %>
}
```

See [templates documentation](#templates).

### Reading the Certificate from Attributes

The SSL certificate can be read from an attribute directly:

```ruby
# Setting the attributes
node.default['mysite']['ssl_key']['content'] =
  '-----BEGIN PRIVATE KEY-----[...]'
node.default['mysite']['ssl_cert']['content'] =
  '-----BEGIN CERTIFICATE-----[...]'

# Creating the certificate
ssl_certificate 'mysite' do
  common_name 'cloud.mysite.com'
  namespace node['mysite']
  # this will read the node['mysite']['ssl_key']['content'] and
  # node['mysite']['ssl_cert']['content'] keys
  source 'attribute'
end
```

Alternative example using a namespace and node attributes:

```ruby
# Setting the attributes
node.default['mysite']['common_name'] = 'cloud.mysite.com'
node.default['mysite']['ssl_key']['source'] = 'attribute'
node.default['mysite']['ssl_key']['content'] =
  '-----BEGIN PRIVATE KEY-----[...]'
node.default['mysite']['ssl_cert']['source'] = 'attribute'
node.default['mysite']['ssl_cert']['content'] =
  '-----BEGIN CERTIFICATE-----[...]'

# Creating the certificate
ssl_certificate 'mysite' do
  namespace node['mysite']
end
```

### Reading the Certificate from a Data Bag

```ruby
ssl_certificate 'mysite' do
  common_name 'cloud.mysite.com'
  source 'data-bag'
  bag 'ssl_data_bag'
  key_item 'key' # data bag item
  key_item_key 'content' # data bag item json key
  cert_item 'cert'
  cert_item_key 'content'
  encrypted true
  secret_file '/path/to/secret/file' # optional
end
```

Alternative example using a namespace and node attributes:

```ruby
# Setting the attributes
node.default['mysite']['common_name'] = 'cloud.mysite.com'

node.default['mysite']['ssl_key']['source'] = 'data-bag'
node.default['mysite']['ssl_key']['bag'] = 'ssl_data_bag'
node.default['mysite']['ssl_key']['item'] = 'key'
node.default['mysite']['ssl_key']['item_key'] = 'content'
node.default['mysite']['ssl_key']['encrypted'] = true
node.default['mysite']['ssl_key']['secret_file'] = '/path/to/secret/file'

node.default['mysite']['ssl_cert']['source'] = 'data-bag'
node.default['mysite']['ssl_cert']['bag'] = 'ssl_data_bag'
node.default['mysite']['ssl_cert']['item'] = 'key'
node.default['mysite']['ssl_cert']['item_key'] = 'content'
node.default['mysite']['ssl_cert']['encrypted'] = true
node.default['mysite']['ssl_cert']['secret_file'] = '/path/to/secret/file'

# Creating the certificate
ssl_certificate 'mysite' do
  namespace node['mysite']
end
```

### Reading the Certificate from Chef Vault

```ruby
ssl_certificate 'mysite' do
  common_name 'cloud.mysite.com'
  source 'chef-vault'
  bag 'ssl_vault_bag'
  key_item 'key' # data bag item
  key_item_key 'content' # data bag item json key
  cert_item 'cert'
  cert_item_key 'content'
end
```

The same example, using a namespace and node attributes:

```ruby
# Setting the attributes
node.default['mysite']['common_name'] = 'cloud.mysite.com'

node.default['mysite']['ssl_key']['source'] = 'chef-vault'
node.default['mysite']['ssl_key']['bag'] = 'ssl_vault_bag'
node.default['mysite']['ssl_key']['item'] = 'key'
node.default['mysite']['ssl_key']['item_key'] = 'content'

node.default['mysite']['ssl_cert']['source'] = 'chef-vault'
node.default['mysite']['ssl_cert']['bag'] = 'ssl_vault_bag'
node.default['mysite']['ssl_cert']['item'] = 'key'
node.default['mysite']['ssl_cert']['item_key'] = 'content'

# Creating the certificate
ssl_certificate 'mysite' do
  namespace node['mysite']
end
```

### Reading the Certificate from Files

```ruby
ssl_certificate 'mysite' do
  common_name 'cloud.mysite.com'
  source 'file'
  key_path '/path/to/ssl/key'
  cert_path '/path/to/ssl/cert'
end
```

The same example, using a namespace and node attributes:

```ruby
# Setting the attributes
node.default['mysite']['common_name'] = 'cloud.mysite.com'

node.default['mysite']['ssl_key']['source'] = 'file'
node.default['mysite']['ssl_key']['path'] = '/path/to/ssl/key'

node.default['mysite']['ssl_cert']['source'] = 'file'
node.default['mysite']['ssl_cert']['path'] = '/path/to/ssl/cert'

# Creating the certificate
ssl_certificate 'mysite' do
  namespace node['mysite']
end
```

### Reading the Certificate from Different Places

You can also read the certificate and the private key from different places each:

```ruby
ssl_certificate 'mysite' do
  common_name 'cloud.mysite.com'

  # Read the private key from chef-vault
  key_source 'chef-vault'
  key_bag 'ssl_vault_bag'
  key_item 'key' # data bag item
  key_item_key 'content' # data bag item json key

  # Read the public cert from a non-encrypted data bag
  cert_source 'data-bag'
  cert_bag 'ssl_data_bag'
  cert_item 'cert'
  cert_item_key 'content'
  cert_encrypted false
end
```

The same example, using a namespace and node attributes:

```ruby
# Setting the attributes
node.default['mysite']['common_name'] = 'cloud.mysite.com'

# Read the private key from chef-vault
node.default['mysite']['ssl_key']['source'] = 'chef-vault'
node.default['mysite']['ssl_key']['bag'] = 'ssl_vault_bag'
node.default['mysite']['ssl_key']['item'] = 'key'
node.default['mysite']['ssl_key']['item_key'] = 'content'

# Read the public cert from a non-encrypted data bag
node.default['mysite']['ssl_cert']['source'] = 'data-bag'
node.default['mysite']['ssl_cert']['bag'] = 'ssl_data_bag'
node.default['mysite']['ssl_cert']['item'] = 'key'
node.default['mysite']['ssl_cert']['item_key'] = 'content'
node.default['mysite']['ssl_cert']['encrypted'] = false

# Creating the certificate
ssl_certificate 'mysite' do
  namespace node['mysite']
end
```

### Creating a Certificate with Subject Alternate Names

```ruby
domain = 'mysite.com'
# SAN for mysite.com, foo.mysite.com, bar.mysite.com, www.mysite.com
node.default[domain]['ssl_cert']['subject_alternate_names'] =
  [domain, "foo.#{domain}", "bar.#{domain}", "www.#{domain}"]

ssl_certificate 'mysite.com' do
  namespace node[domain]
  key_source 'self-signed'
  cert_source 'self-signed'
end
```

### Reading Key, Certificate and Intermediary from a Data Bag

```ruby
cert_name = 'chain-data-bag'
node.default[cert_name]['ssl_key']['source'] = 'data-bag'
node.default[cert_name]['ssl_key']['bag'] = 'ssl'
node.default[cert_name]['ssl_key']['item'] = 'key'
node.default[cert_name]['ssl_key']['item_key'] = 'content'
node.default[cert_name]['ssl_key']['encrypted'] = true
node.default[cert_name]['ssl_cert']['source'] = 'data-bag'
node.default[cert_name]['ssl_cert']['bag'] = 'ssl'
node.default[cert_name]['ssl_cert']['item'] = 'cert'
node.default[cert_name]['ssl_cert']['item_key'] = 'content'
node.default[cert_name]['ssl_chain']['name'] = 'chain-ca-bundle.pem'
node.default[cert_name]['ssl_chain']['source'] = 'data-bag'
node.default[cert_name]['ssl_chain']['bag'] = 'ssl'
node.default[cert_name]['ssl_chain']['item'] = 'chain'
node.default[cert_name]['ssl_chain']['item_key'] = 'content'

ssl_certificate 'chain-data-bag' do
  namespace cert_name
end
```

### Creating a Certificate from a Certificate Authority

```ruby
ca_cert = '/usr/share/pki/ca-trust-source/anchors/CA.crt'
ca_key = '/usr/share/pki/ca-trust-source/anchors/CA.key'

cert = ssl_certificate 'test' do
  namespace node['test.com']
  key_source 'self-signed'
  cert_source 'with_ca'
  ca_cert_path ca_cert
  ca_key_path ca_key
end
```

### Reading the CA Certificate from a Chef Vault Bag

In this example, we read the CA certificate from a Chef Vault and use it to generate the shelf-signed certificates:

```ruby
# Create the CA from a Chef Vault bag

ca_cert = ssl_certificate 'ca.example.org' do
  common_name 'ca.example.org'
  source 'chef-vault'
  bag 'ssl'
  item 'ca_cert'
  key_item_key 'key_content'
  cert_item_key 'cert_content'
end

ssl_certificate 'example.org' do
  cert_source 'with_ca'
  ca_cert_path ca_cert.cert_path
  ca_key_path ca_cert.key_path
end
```

The vault bag content:

```json
{
  "id": "ca_cert",
  "key_content": "-----BEGIN RSA PRIVATE KEY-----\nMIIE [...]",
  "cert_content": "-----BEGIN CERTIFICATE-----\nMIIE [...]"
}
```

The knife command to create the vault bag item:

    $ knife vault create ssl ca_cert [...]

### Managing Certificates Via Attributes

Sometimes you may want to use only node attributes to manage some of your SSL Certificates (instead of [the `ssl_certificate` resource](#ssl_certificate)). You can do it using the `ssl_certificate::attr_apply` recipe and configuring them inside the `node['ssl_certificate']['items']` array:

```ruby
run_list(
  'recipe[ssl_certificate::attr_apply]'
)
override_attributes(
  'ssl_certificate' => {
    'items' => [
      {
        'name' => 'domain.com',
        'dir' => '/etc/nginx/ssl',
        'item' => 'domain_com',
        'source' => 'chef-vault',
        'bag' => 'ssl-vault',
        'key_item_key' => 'key',
        'cert_item_key' => 'cert',
        'chain_item_key' => 'chain',
        'chain_source' => 'chef-vault',
        'chain_bag' => 'ssl-vault',
        'chain_item' => 'domain_com',
        'chain_name' => 'domain.com.chain.pem'
      }
    ]
  }
)
```

Testing
=======

See [TESTING.md](https://github.com/onddo/ssl_certificate-cookbook/blob/master/TESTING.md).

## ChefSpec Matchers

### ssl_certificate(name)

Helper method for locating a `ssl_certificate` resource in the collection.

```ruby
resource = chef_run.ssl_certificate('postfixadmin')
expect(resource).to notify('service[apache2]').to(:restart)
```

### create_ssl_certificate(name)

Assert that the Chef run creates ssl_certificate.

```ruby
expect(chef_run).to create_ssl_certificate('cloud.mysite.com')
```

Contributing
============

Please do not hesitate to [open an issue](https://github.com/onddo/ssl_certificate-cookbook/issues/new) with any questions or problems.

See [CONTRIBUTING.md](https://github.com/onddo/ssl_certificate-cookbook/blob/master/CONTRIBUTING.md).

TODO
====

See [TODO.md](https://github.com/onddo/ssl_certificate-cookbook/blob/master/TODO.md).


License and Author
==================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Raul Rodriguez](https://github.com/raulr) (<raul@onddo.com>)
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@onddo.com>)
| **Contributor:**     | [Steve Meinel](https://github.com/smeinel)
| **Contributor:**     | [Djuri Baars](https://github.com/dsbaars)
| **Contributor:**     | [Elliott Davis](https://github.com/elliott-davis)
| **Contributor:**     | [Jeremy MAURO](https://github.com/jmauro)
| **Contributor:**     | [Benjamin Nørgaard](https://github.com/blacksails)
| **Contributor:**     | [Stanislav Bogatyrev](https://github.com/realloc)
| **Contributor:**     | [Karl Svec](https://github.com/karlsvec)
| **Copyright:**       | Copyright (c) 2014-2015, Onddo Labs, SL. (www.onddo.com)
| **License:**         | Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
