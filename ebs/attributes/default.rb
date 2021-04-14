###
# Do not use this file to override the deploy cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "ebs/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'ebs/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

default[:ebs][:devices] ||= {}
default[:ebs][:raids] ||= {}
default[:ebs][:mdadm_chunk_size] = '256'
default[:ebs][:md_read_ahead] = '65536' # 64k

if BlockDevice.on_kvm?
  skip_chars = ebs[:devices].keys.size
  ebs[:raids].each do |raid_device, config|
    new_raid_devices = BlockDevice.translate_device_names(config[:disks], skip_chars).map{|names| names[1]}
    set[:ebs][:raids][raid_device][:disks] = new_raid_devices
    skip_chars = new_raid_devices.size
  end
end

include_attribute "ebs::customize"
