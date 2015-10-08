opsworks\_custom\_env
===================

This cookbook allows Rails apps on [Amazon OpsWorks](http://aws.amazon.com/opsworks/) to separate their configuration from their code. In keeping with [Heroku's twelve-factor app](http://www.12factor.net/config), the configuration is made available to the app's environment.

To accomplish this, the cookbook maintains a `config/application.yml` file in each respective app's deploy directory. E.g.:

    ---
    FOO: "http://www.yahoo.com"
    BAR: "1001"

Your application can then load its settings directly from this file, or use [Figaro](https://github.com/laserlemon/figaro) to automatically make these settings available in the app's `ENV` (recommended).

Configuration values are specified in the [stack's custom JSON](http://docs.aws.amazon.com/opsworks/latest/userguide/workingstacks-json.html). Example:

    {
      "custom_env": {
        "my_app": {
          "FOO": "http://www.yahoo.com",
          "BAR": "1001"
        }
      },
      
      "deploy": {
        "my_app": {
          "symlink_before_migrate": {
            "config/application.yml": "config/application.yml"
          }
        }
      }
    }

**Note** that the `symlink_before_migrate` attribute is necessary so that OpsWorks automatically symlinks the shared file when setting up release directories or deploying a new version.


Caveats
-------

At the moment, only default Opsworks configurations for Apache/Passenger and Unicorn/Nginx style Rails apps are supported.


Opsworks Set-Up
---------------

* Add `custom_env` and `symlink_before_migrate` attributes to the stack's custom JSON as in the example above.
* Associate the `opsworks_custom_env::configure` custom recipe with the _Deploy_ event in your rails app's layer.

A deploy isn't necessary if you just want to update the custom configuration. Instead, update the stack's custom JSON, then choose to _Run Command_ > _execute recipes_ and enter `opsworks_custom_env::configure` into the _Recipes to execute_ field. Executing the recipe will write an updated `application.yml` file and restart unicorn workers.

Copyright and License
-------

(c) 2013-2014 [Joey Aghion](http://joey.aghion.com), [Artsy](http://artsy.net). See [LICENSE](LICENSE) for details.

