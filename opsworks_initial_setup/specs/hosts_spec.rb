require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::hosts' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates entries for all hosts on the same stack which are online ' do
    node[:opsworks][:layers].each do |layer_name, layer_config|
      layer_config[:instances].each do |instance_name, instance_config|
        if !seen.include?(instance_name) && instance_config[:private_ip]
          file('/etc/hosts').must_include "#{Resolv.getaddress(instance_config[:private_ip])} #{instance_name}"
          if instance_config[:ip]
            file('/etc/hosts').must_include "#{Resolv.getaddress(instance_config[:ip])} #{instance_name}-ext"
          end
          seen << instance_name
        end
      end
    end
  end
end
