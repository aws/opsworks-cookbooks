Unicorn Chef Cookbook
===========================

This configures unicorn for use with rack, rails, and sinatra apps.

It also reads any `env` variables you wish to set for this node, and sets up unicorn to have those values available to the webapp.

It does this by updating `unicorn.conf` to include the line(s) `ENV['YOUR_CUSTOM_ENV'] = 'YOUR_CUSTOM_VALUE'`.

Recipes
---------------------------

###### Setup
* `unicorn`: Default setup for unicorn
* `unicorn::rack`: Setup needed for Rack-based apps, like Rails and Sinatra apps.

Databag
---------------------------


```json
{
  "service_realm": "production",
  "web_application_type": "sinatra",
  "opsworks": {
    "rack_stack": { "name": "nginx_unicorn", "recipe": "unicorn::rack", "service": "unicorn" },
  },
  "deploy": {
    "MYAPPNAME": {
      "application_type": "sinatra",
      "rack_env": "production",
      "environment": { "rack_env": "production" },
      "env": {
        "MY_APP_ENV1": "MY_CUSTOM_VALUE_1",
        "MY_APP_ENV2": "MY_CUSTOM_VALUE_2",
        ...
      }
    }
  }
}
```


