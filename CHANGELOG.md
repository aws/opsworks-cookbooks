- Using mariadb as a binary compatible replacement for mysql for rhel 7 servers
- Updated the monit systemd config to prevent systemd from sending the kill signal to processes monitored by monit.
# v340 2015-05-05
- Reverts a breaking commit that resulted in an invalid deploy destination
directory. https://github.com/aws/opsworks-cookbooks/issues/301
