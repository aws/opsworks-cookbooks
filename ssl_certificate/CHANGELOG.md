ssl_certificate CHANGELOG
=========================

This file is used to list changes made in each version of the `ssl_certificate` cookbook.

## v1.4.0 (2015-04-05)

* Add `attr_apply` recipe: Create a certificate list from attributes ([issue #10](https://github.com/onddo/ssl_certificate-cookbook/pull/10), thanks [Stanislav Bogatyrev](https://github.com/realloc)).
* Fix invalid metadata ([issue #11](https://github.com/onddo/ssl_certificate-cookbook/pull/11), thanks [Karl Svec](https://github.com/karlsvec)).
* Update RuboCop to `0.29.1` (fix some new offenses).

## v1.3.0 (2015-02-03)

* Add `namespace['source']` common attribute.
* Fix chef vault source: `chef_gem` method not found error.
* Fix `#data_bag_read_fail` method name.
* README: Fix *item_key* attribute name.

## v1.2.2 (2015-01-16)

* Fix unit tests: Run the tests agains Chef 11 and Chef 12.

## v1.2.1 (2015-01-16)

* Fix *key content* when using `'file'` source.

## v1.2.0 (2015-01-07)

* Fix file source path in attributes.
* Fix *"stack level too deep"* error with CA certificates.
* Nginx template: Add `ssl on;` directive.
* Remove setting CA in apache template (bad idea).
* Rename template helpers to service helpers.
 * Document *ServiceHelpers* methods.
* README: Some small fixes.

## v1.1.0 (2015-01-02)

* Fix FreeBSD support.
* Allow to change the certificate file owner.
* Web server template improvements:
 * Fix Apache 2.4 support.
 * Add partial templates for Apache and nginx.
 * Add CA certificate file support.
 * Add adjustable SSL compatibility level.
 * Add OCSP stapling support.
 * Enable HSTS and stapling by default.
* Fix all integration tests.

## v1.0.0 (2014-12-30)

* Bugfix: Cannot read SSL intermediary chain from data bag.
* Fix Directory Permissions for Apache `2.4` ([issue #7](https://github.com/onddo/ssl_certificate-cookbook/pull/7), thanks [Elliott Davis](https://github.com/elliott-davis)).
* Add CA support for self signed certificates ([issue #8](https://github.com/onddo/ssl_certificate-cookbook/pull/8), thanks [Jeremy MAURO](https://github.com/jmauro)).
* Apache template:
  * Disable `SSLv3` by default (**breaking change**).
  * Add chained certificate support.
  * Allow to change the cipher suite and protocol in the apache template.
* Big code clean up:
  * Split resource code in multiple files.
  * Remove duplicated code.
  * Integrate with foodcritic.
  * Integrate with RuboCop.
  * Integrate with `should_not` gem.
  * Integrate with travis-ci, codeclimate and gemnasium.
  * Homogenize license headers.
* Add ChefSpec unit tests.
* Add integration tests: bats and Serverspec.
* Update Gemfile and Berksfile files.
* Add Guardfile.
* README:
  * Multiple fixes and improvements ([issue #9](https://github.com/onddo/ssl_certificate-cookbook/pull/9), thanks [Benjamin Nørgaard](https://github.com/blacksails)).
  * Split in multiple files.
  * Add TOC.
  * Add badges.
* Add LICENSE file.

## v0.4.0 (2014-11-19)

* Add Apache 2.4 support ([issue #4](https://github.com/onddo/ssl_certificate-cookbook/pull/4), thanks [Djuri Baars](https://github.com/dsbaars)).
* Add supported platform list.
* kitchen.yml completed and updated.

## v0.3.0 (2014-11-03)

Special thanks to [Steve Meinel](https://github.com/smeinel) for his great contributions.

* Add Subject Alternate Names support for certs ([issue #2](https://github.com/onddo/ssl_certificate-cookbook/pull/2), thanks [Steve Meinel](https://github.com/smeinel)).
* Add support for deploying an intermediate cert chain file ([issue #3](https://github.com/onddo/ssl_certificate-cookbook/pull/3), thanks [Steve Meinel](https://github.com/smeinel)).
* ChefSpec matchers: add helper methods to locate LWRP resources.
* README: Chef `11.14.2` required.
* TODO: complete it with more tasks and use checkboxes.

## v0.2.1 (2014-09-14)

* `ssl_certificate` resource notifications fixed (issue [#1](https://github.com/onddo/ssl_certificate-cookbook/pull/1), thanks [Matt Graham](https://github.com/gadgetmg) for reporting)

## v0.2.0 (2014-08-13)

* Added ChefSpec ssl_certificate matcher
* Fixed: undefined method "key_path" for nil:NilClass
* README: fixed ruby syntax highlighting in one example

## v0.1.0 (2014-04-15)

* Initial release of `ssl_certificate`
