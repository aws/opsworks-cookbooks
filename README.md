These are the standard Chef cookbooks used by Scalarium. 

If you want to override any template (like the Rails database.yml or the Apache vhost definition), this is the
place to look for the originals.

The stable branch is the one deployed on the instances.

See also <http://support.scalarium.com>

Some of these cookbooks rely on functionality included in our [fork of
Chef](http://github.com/peritor/chef/tree/scalarium-0.8-stable). That involves either changes already merged in
[Chef upstream](http://github.com/opscode/chef) or something as simple as retrying to install a Rubygem.

LICENSE: Unless otherwise stated, cookbooks/recipes originated by Peritor/Scalarium are licensed under the Apache 2.0
license.  See the LICENSE file. Some files are just imported and authored by others. Their license will of course apply.
