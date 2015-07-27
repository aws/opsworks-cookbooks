# v3425 2015-07-27
- ECS support for Amazon Linux and Ubuntu.
# v3422 2015-06-29
- Full support of Red Hat Enterprise Linux 7.
- Make /etc/hosts generation more resilient to errors.
# v3421 2015-06-11
- Option to override db package name for Red Hat Enterprise Linux 7
- Updated the monit systemd config to prevent systemd from sending the kill signal to processes monitored by monit.
# v340 2015-05-05
- Reverts a breaking commit that resulted in an invalid deploy destination
directory. https://github.com/aws/opsworks-cookbooks/issues/301
