opsworks-cookbooks
==================

**This repo contains cookbooks used by AWS OpsWorks for Chef versions 11.10, 11.4 and 0.9.**

To get started with AWS OpsWorks cookbooks for all versions of Chef see the [cookbook documentation](https://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook.html).

If you want to override any template (like the Rails database.yml or the Apache
vhost definition), this is the place to look for the originals.

Chef version 12
------------------------------------

**For Chef 12.2 Windows and Chef 12 Linux there are no built-in cookbooks**

Chef versions 11.10, 11.4 and 0.9
----------------------------------

These branches contain the cookbooks that are used by official OpsWorks releases:

- **Chef 11.10**: [release-chef-11.10](https://github.com/aws/opsworks-cookbooks/tree/release-chef-11.10)
- **Chef 11.4**: [release-chef-11.4](https://github.com/aws/opsworks-cookbooks/tree/release-chef-11.4) (deprecated)
- **Chef 0.9**: [release-chef-0.9](https://github.com/aws/opsworks-cookbooks/tree/release-chef-0.9) (deprecated)

These branches reflect the upcoming changes for the next release:

- **Chef 11.10**: [master-chef-11.10](https://github.com/aws/opsworks-cookbooks/tree/master-chef-11.10)
- **Chef 11.4**: [master-chef-11.4](https://github.com/aws/opsworks-cookbooks/tree/master-chef-11.4) (deprecated)
- **Chef 0.9**: [master-chef-0.9](https://github.com/aws/opsworks-cookbooks/tree/master-chef-0.9) (deprecated)

The `master` branch is not used since AWS OpsWorks supports multiple configuration managers.

See also <https://aws.amazon.com/opsworks/>

LICENSE: Unless otherwise stated, cookbooks/recipes originated by Amazon Web Services are licensed
under the [Apache 2.0 license](http://aws.amazon.com/apache2.0/). See the LICENSE file. Some files
are just imported and authored by others. Their license will of course apply.
