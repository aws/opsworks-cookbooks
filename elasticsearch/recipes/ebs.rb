[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::Extensions }

# Install the Fog gem dependencies
#
value_for_platform_family(
  [:ubuntu, :debian]               => %w| build-essential libxslt1-dev libxml2-dev |,
  [:rhel, :centos, :suse, :amazon] => %w| gcc gcc-c++ make libxslt-devel libxml2-devel |
).each do |pkg|
  package(pkg) { action :nothing }.run_action(:upgrade)
end

# Install the Fog gem for Chef run
#
chef_gem("fog") do
  version '1.21.0'
  action :install
end

# Create EBS for each device with proper configuration
#
# See the `attributes/data` file for instructions.
#
node.elasticsearch[:data][:devices].each do |device, params|
  if params[:ebs] && !params[:ebs].keys.empty?
    create_ebs device, params
  end
end
