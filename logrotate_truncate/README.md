# logrotate_truncate

This recipe is intended to keep log files at a maximum determined size.

It's built based on the 'truncate' linux command and crontab.

Recipes available:

* logrotate_truncate::default - setup the environment and put crontab entry to perform the job
* logrotate_truncate::truncate - manualy executes the script to truncate logs present in config file

# How it works ?

It truncates log files defined in /etc/truncate_logfiles.conf

This config file is dynamicaly populated with:

* A path pattern /srv/www/<app_name>/shared/log/*, for each application are running on a given node, this is done by checking node["opsworks"]["applications"]
* A list of paths defined by the custom opsworks JSON

The frequency is defined by a crontab entry for the 'root' user.

Default cron-expression would be:

```javascript
    “custom_cron”:{
			“minute”: “*/10”,
			“hour”:”*”,
			“weekday”:”*”
		}
```

Which can be overriden by the opsworks custom JSON.

OpsWorks custom JSON entry would be like that:

```javascript
 "logtruncate": {
     "custom_cron":{
      "minute": "*/3",
      "hour":"*",
      "weekday":"*"
      },
    "paths": [
      "/tmp/teste_log_truncate/*",
      "/tmp/teste_log_truncate2/*"
    ]
  }
```


