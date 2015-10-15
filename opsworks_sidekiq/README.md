opsworks-sidekiq
================

Opsworks sidekiq cookbook for Ubuntu and Rails or non-rails sidekiq deploys

## Installation instructions

1) Make sure you have Redis installed.  This cookbook seems decent: https://github.com/brianbianco/redisio

2) Add this cookbook to your list of Custom Cookbooks

3) Add the deploy recipe in this cookbook to your Application's Deploy custom recipe.  This should be place AFTER your application is deployed to ensure Sidekiq uses the new code checked out.

4) Configure your sidekiq custom JSON to specify Sidekiq should be deployed with this app:


### Supported Options

Currently supported options for the Sidekiq deploy recipe are:

* start_command

The command to start sidekiq.  This will run relative to the root of the current release path.

Defaults to:

```bash
bundle exec sidekiq -e production -C config/sidekiq.yml -r ./config/boot.rb 2>&1 >> log/sidekiq.log
```

### Sample Chef JSON configuration

Here is an example Custom JSON which overrides overrides the start_command to set the sidekiq environment to staging:

```json
{
  "deploy": {
    "YOURAPPNAME": {
      "sidekiq": {
        "start_command": "bundle exec sidekiq -e staging -C config/sidekiq.yml -r ./config/boot.rb 2>&1 >> log/sidekiq.log"
      }
    }
  }
}
```

Here is the minimum deploy config required:
```json
{
  "deploy": {
    "YOURAPPNAME": {
      "sidekiq": {}
    }
  }
}
```

### Environment variables

All Opsworks environment_variables defined within your application will be exposed to the Sidekiq process via the upstart script.
