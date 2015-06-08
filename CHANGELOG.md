- Option to override db package name for rhel7
- Updated the monit systemd config to prevent systemd from sending the kill signal to processes monitored by monit.
# v340 2015-05-05
- Reverts a breaking commit that resulted in an invalid deploy destination
directory. https://github.com/aws/opsworks-cookbooks/issues/301
