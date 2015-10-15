[opsworks_sidekiq](https://github.com/drakerlabs/opsworks_sidekiq)
====================

This cookbook sets up an [AWS OpsWorks](http://aws.amazon.com/opsworks/) instance to run [sidekiq](http://sidekiq.org/) for a Rails application.

Adapted from Joey Aghion's [opsworks_delayed_job](https://github.com/joeyAghion/opsworks_delayed_job).


This cookbook uses monit to manage 1 or more Sidekiq *processes* per machine, each with a customized concurrency level. This recipe is heavily integrated into the opsworks rails recipes.

Prerequisites
-------------

Assumes you have redis installed, configured and the connection with sidekiq established. This does not handle any redis connection setup. You can do this on aws elasticache

Configuration Examples
----------------------

By default, no sidekiq processes will be started.

### Custom JSON

JSON such as the following added as custom JSON to the stack:

```json
{
  "sidekiq": {
    "YOUR_APP_NAME": {
      "slacker": {
        "process_count": 2,
        "config" : {
          "concurrency": 10,
          "verbose": false,
          "queues": ["critical", "default", "low"]
        }
      },
      "hard_worker": {
        "config": {
          "concurrency": 40,
          "queues": [
            ["often", 7],
            ["default", 5],
            ["seldom", 3]
          ]
        }
      }
    }
  }
}
```

Will result in 3 monit managed sidekiq *processes* named `sidekiq_slacker1`, `sidekiq_slacker2`, and `sidekiq_hard_worker1` on any instance with this set of cookbooks run. Each instance will also have `config/sidekiq_slacker1.yml`, `config/sidekiq_slacker2.yml` and `config/sidekiq_hard_worker1.yml` files containing the yaml representation of the contents of the config JSON object. By default there would only be one hard_worker process because `process_count` was not set. In this case the `config/sidekiq_slacker1.yml` would look like:

```yaml
:concurrency: 10
:verbose: false
:queues
  - critical
  - default
  - low
```

By just converting your JSON config object to yaml we support any plugins that use sidekiq.yml.

You can use any name, such as "import_process", "one", "emailer", "slacker", or "fred". You are not stuck to meaningless names such as "worker1".

If the instance is not in a opsworks Rails application server layer then a database.yml and memcached.yml will be generated if they don't exist.

### 'Wrapper/Layer' Cookbooks

For more fine grained control and less brittle JSON configuration it is suggested to use wrapper/layer recipes and override attributes in it.

For example, if you have one server that imports files only available to that one server, and another that performs other jobs you might have two custom layers, "sidekiq_import" and "sidekiq_rest". For each layer create a cooresponding cookbook. Each would have an `attributes/default.rb` file that sets the proper attributes, for example:

`cookbooks/sidekiq_import/attributes/default.rb`

```ruby
override['sidekiq']['YOUR_APP_NAME']['importer']['process_count'] = 4
override['sidekiq']['YOUR_APP_NAME']['importer']['config']['concurrency'] = 20
override['sidekiq']['YOUR_APP_NAME']['importer']['config']['queues'] = ['import_csv', 'import_xml', 'import_json']
# ...

```

`cookbooks/sidekiq_rest/attributes/default.rb`

```ruby
override['sidekiq']['YOUR_APP_NAME']['worker']['process_count'] = 4
override['sidekiq']['YOUR_APP_NAME']['worker']['config']['concurrency'] = 40
override['sidekiq']['YOUR_APP_NAME']['worker']['config']['queues'] = ['critical', 'default', 'low']
```


OpsWorks Set-Up
---------------

The layer's custom chef recipes should be associated with events as follows:

* **Setup**: `opsworks_sidekiq::setup`
* **Configure**: `opsworks_sidekiq::configure`
* **Deploy**: `opsworks_sidekiq::deploy`
* **Undeploy**: `opsworks_sidekiq::undeploy`
* **Shutdown**: `opsworks_sidekiq::stop`


Logging
-------

Logging can be done to either a file or syslog.

To log to a file simply include the logfile path in the config. EG:

```ruby
override['sidekiq']['YOUR_APP_NAME']['worker']['config']['logfile'] = '/var/log/sidekiq_worker'
```

To log to syslog set the application syslog property to true.

```ruby
override['sidekiq']['YOUR_APP_NAME']['syslog'] = true
```

License
-------

See [LICENSE](LICENSE).

Adaption to opsworks_sidekiq  &copy; 2013 Draker Inc.
Original opsworks_delayed_job &copy; 2013 Joey Aghion, Artsy Inc.
