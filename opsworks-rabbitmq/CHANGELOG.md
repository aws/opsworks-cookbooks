# v0.3.1

* Revert [rabbitmq](https://github.com/jjasghar/rabbitmq) cookbook version down
  to ~2.4 due to incompatibility issues with Chef 11.10 on AWS OpsWorks

# v0.3

* Added `opsworks_rabbitmq::user_management` for user management
* Added `opsworks_rabbitmq::virtualhost_management` for vhost management
* ChefSpec unit tests for the above recipes

# v0.2.1

* Added `opsworks_rabbitmq::policy_management` needed for setting up High
  Availability queues on a cluster
* Locked [erlang](https://github.com/opscode-cookbooks/erlang) cookbook version
  to 1.5.4
* ChefSpec unit tests added
* Travis CI support

# v0.2

* Removed `opsworks_rabbitmq::dns` recipe (functionality now provided by
  [opsworks_route53](https://github.com/verdigris-cookbooks/opsworks_route53)
  cookbook)
* Fixed **service cannot be found** error in `opsworks_rabbitmq::configure`
  recipe

# v0.1.1

* Fixed a minor bug with AWS Route53 zone ID attribute not being resolved
correctly

# v0.1.0

* Initial release based on original RabbitMQ cookbook
