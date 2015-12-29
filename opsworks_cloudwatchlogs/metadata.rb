name "opsworks_cloudwatchlogs"
description "CloudWatch Logs Integration"
maintainer "AWS OpsWorks"
license "Apache 2.0"
version "1.0.0"

recipe "opsworks_cloudwatchlogs::default", "Uses install or uninstall recipe"
recipe "opsworks_cloudwatchlogs::install", "Install CloudWatch Logs agent."
recipe "opsworks_cloudwatchlogs::uninstall", "Remove CloudWatch Logs agent and config files."
