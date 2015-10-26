# v3427 2015-09-11
- Updating the default 2.0, 2.1 and 2.2 versions of Ruby to 2.0.0p647, 2.1.7 and 2.2.3

# v3426 2015-08-27
- Improving download from s3 by replacing s3curl with s3_file cookbook.
- Change the default Node.js version to v0.12.7
- Logging added for Node.js apps. STDOUT and STDERR logged and rotated in the shared/log directory.
- Make custom cookbook submodule checkout update explicit.
- Added workaround for https://github.com/aws/opsworks-cookbooks/issues/213 that will check to ensure bind mounts have been made before the deploy directory is created.

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
