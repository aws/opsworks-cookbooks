0.6 (in progress)
---
* Restart workers directly rather than with `node[:opsworks][:rails_stack][:restart_command]`. Fixes [#9](https://github.com/joeyAghion/opsworks_delayed_job/issues/9) ([#10](https://github.com/joeyAghion/opsworks_delayed_job/pull/10)). Note that this may break timing of Chef deploy hooks.
* Change default path for delayed_job executable from `script` to `bin` ([#11](https://github.com/joeyAghion/opsworks_delayed_job/pull/11)). Set `node[:delayed_job][:path_to_script]` to `script` to achieve old behavior.
