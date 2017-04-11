#
# Cookbook Name:: rabbitmq_test
# Recipe:: cook-2151-3489
#
# This recipe exists to ensure that minitest tests are run.

include_recipe 'rabbitmq::default'

# HACK: Give rabbit time to spin up before the tests, it seems
# to be responding that it has started before it really has
execute 'sleep 10' do
  action :nothing
  subscribes :run, "service[#{node['rabbitmq']['service_name']}]", :delayed
end
