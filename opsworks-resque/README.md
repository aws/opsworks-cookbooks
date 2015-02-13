# opsworks-resque cookbook

This is a very simple cookbook to deploy a pool of resque workers directly in Amazon OpsWorks

# Requirements

# Usage

## Rails App Server layer type

If you're using a _Rails App Server_ layer type you'll need to add the following custom recipes to your layer:

**Setup**

opsworks-resque::setup

**Deploy**

opsworks-resque::restart

**Undeploy**

opsworks-resque::stop

## Other layer types

If you're using another layer type you'll need to configure some Rails recipes too:

**Setup**

opsworks-resque::setup

**Configure**

rails::configure

**Deploy**

deploy::rails opsworks-resque::restart

**Undeploy**

opsworks-resque::stop deploy::rails-undeploy

# Attributes

It expects an array with the queues of workers to run, for example
```json
"resque": {
  "app-name": {
    "workers": {
      "*": 1
    }
  }
}
```

if you're not using the _Rails App Server_ layer type you'll also need to specify a `rails_env` like so:

```json
"resque": {
  "app-name": {
    "rails_env": "development",
    "workers": {
      "*": 1
    }
  }
}
```

# Recipes

**opsworks-resque::setup** - initial setup
**opsworks-resque::restart** - restart the workers (after deploy)
**opsworks-resque::stop** - stop the workers (shutdown)

# Author

Author:: Pedro Axelrud (<pedroaxl@gmail.com>)