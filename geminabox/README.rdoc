== Geminabox On Chef

Configures and installs {geminabox}[http://github.com/cwninja/geminabox] via Chef to provide
a private (and optionally secured) gem store.

== Features

* Optional SSL
* Optional user/pass authentication

== Requirements

Currently this cookbook uses a defined set of applications with the
intention to expand coverage of other options (like passenger, thin,
apache, monit, etc). At present, these are supported:

* Nginx
* Unicorn
* Bluepill

== Suggested additions

It is highly suggested to include the BagConfig cookbook for storing sensitive
configuration values within encrypted data bag entries:

http://community.opscode.com/cookbooks/bag_config

== What you get

By default, this cookbook will provide a Geminabox instance available
via http://node_address. It uses a unicorn + nginx pairing with bluepill
monitoring the unicorn processes. It also comes with an upstart configuration.

== Adding extras

=== SSL

To enable SSL, provide a key and cert pair:

  node[:geminabox][:ssl] = {:key => '/path/to/ssl.key', :cert => '/path/to/ssl.cert', :enabled => true}

You can also provide the the actual key and cert pair in the attributes (though
if this approach is used, it is advised to use the BagConfig cookbook and encrypt
the data bag entry).

=== Authentication

To enable authentication, provide a path to the htpasswd file to use or the raw
contents of the htpasswd file:

  node[:geminabox][:auth_required] = '/path/to/htpasswd.file'

or, you can provide a hash of user/password pairs and have the auth file dynamically
created:

  node[:geminabox][:auth_required] = {'user1' => 'secret'}

Again, with providing plaintext passwords, it is suggested to use the BagConfig cookbook
and encrypt the configuration data bag entry.

Finally, the password file can be provided via data bag.  There are two ways the data bag can
be formatted. First is providing the content of an htpasswd generated file. The second is to
provide username/password pairs in the data bag.

== Issues

Please report any bugs to the {issues}[http://github.com/chrisroberts/cookbook-geminabox] section on the github repo.
If you have fixes, updates or new features, please fork and send a pull request

== Thanks

Many thanks to {Tom Lea}[http://github.com/cwninja] for {Geminabox}[http://github.com/cwninja/geminabox]

== License

MIT License (see LICENSE)
