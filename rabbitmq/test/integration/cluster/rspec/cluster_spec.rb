require 'spec_helper'

describe file('/var/lib/rabbitmq/.erlang.cookie') do
  it { should be_file }
end

describe file('/etc/rabbitmq/rabbitmq.config') do
  it { should be_file }
  its(:content) { should match /^    {cluster_nodes, {.*}},$/ } # rubocop:disable all
end # rubocop:enable all
