opsworks-dotenv
===============

Configure the environment for you Rails application using OpsWorks, Chef and Dotenv


### install

Add the Dotenv gem to your `Gemfile`

```ruby
gem 'dotenv-rails'
```

run bundle

```bash
$ bundle
```

as soon as possible, load the environment through Dotenv


```ruby
# application.rb
require File.expand_path('../boot', __FILE__)
require 'dotenv'
Dotenv.load

```


### configure

In the OpsWorks stack dashboard click on stack Settings and supply your ENV configuration.
For example:

```json
{
  "deploy":{
    "app_name":{
      "symlink_before_migrate":{
        ".env" : ".env"
      },
      "app_env": {
        "YOUR_ENV_KEY": "KEY_VALUE",
        "ANOTHER_ENV_KEY": "SECOND_VALUE"
      }
    }
  }
}
```

The `symlink_before_migrate` key just tells OpsWorks to create a link to `.env` file in `shared`
application folder into  `current`, so it can be picked up by Rails.

You can now deploy your app and enjoy the `ENV`



