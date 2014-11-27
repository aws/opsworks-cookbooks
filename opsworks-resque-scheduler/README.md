# opsworks-resque-scheduler cookbook

This is a very simple cookbook to deploy resque scheduler on a simple instance at Amazon OpsWorks

# Requirements

# Usage

In your custom layer, you must add this recipes to each stage

**Configure**

rails::configure
opsworks-resque-scheduler::configure

**Deploy**

deploy::rails
opsworks-resque-scheduler::restart

**Shutdown**

opsworks-resque-scheduler::stop

# Attributes

It expects an array with the queues of workers to run, for example
```ruby
default['resque']['path'] = "/srv/www/mailee_staging/current"
default['resque']['rails_env'] = "preproduction"

```

# Recipes

**opsworks-resque-scheduler::configure** - initial setup
**opsworks-resque-scheduler::restart** - restart the workers (after deploy)
**opsworks-resque-scheduler::stop** - stop the workers (shutdown)

# Author

Author:: Pedro Axelrud (<pedroaxl@gmail.com>)
