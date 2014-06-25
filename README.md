opsworks-cookbooks
==================

**These are the standard Chef cookbooks used by AWS OpsWorks.**

If you want to override any template (like the Rails database.yml or the Apache
vhost definition), this is the place to look for the originals.

Branches for current Chef versions
----------------------------------

These branches are currently used by OpsWorks on your instance.

- **Chef 11.10**: [release-chef-11.10](https://github.com/aws/opsworks-cookbooks/tree/release-chef-11.10)
- **Chef 11.4**: [release-chef-11.4](https://github.com/aws/opsworks-cookbooks/tree/release-chef-11.4)
- **Chef 0.9**: [release-chef-0.9](https://github.com/aws/opsworks-cookbooks/tree/release-chef-0.9)

Upcoming changes
----------------

These branches reflect the upcoming changes for the next release.

- **Chef 11.10**: [master-chef-11.10](https://github.com/aws/opsworks-cookbooks/tree/master-chef-11.10)
- **Chef 11.4**: [master-chef-11.4](https://github.com/aws/opsworks-cookbooks/tree/master-chef-11.4)
- **Chef 0.9**: [master-chef-0.9](https://github.com/aws/opsworks-cookbooks/tree/master-chef-0.9)


The `master` branch is no longer used since AWS OpsWorks supports multiple
configuration managers now.

See also <https://aws.amazon.com/opsworks/>

LICENSE: Unless otherwise stated, cookbooks/recipes originated by Amazon Web Services are licensed
under the [Apache 2.0 license](http://aws.amazon.com/apache2.0/). See the LICENSE file. Some files
are just imported and authored by others. Their license will of course apply.
