# opsworks-resque cookbook

This is a very simple cookbook to deploy a pool of resque workers directly in Amazon OpsWorks

# Requirements

# Usage

In your custom layer, you must add this recipes to each stage

**Configure**

rails::configure
opsworks-resque::configure

**Deploy**

deploy::rails
opsworks-resque::restart

**Shutdown**

opsworks-resque::stop

# Attributes

It expects an array with the queues of workers to run, for example
```ruby
default['resque']['path'] = "/srv/www/mailee_staging/current"
default['resque']['workers'] = {"*" => 2, "images" => 1} # 2 workers for queue * and 1 worker for queue images
default['resque']['rails_env'] = "production"

```

# Recipes

**opsworks-resque::configure** - initial setup
**opsworks-resque::restart** - restart the workers (after deploy)
**opsworks-resque::stop** - stop the workers (shutdown)

# Author

Author:: Pedro Axelrud (<pedroaxl@gmail.com>)
