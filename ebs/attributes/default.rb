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
  Chef::Log.info("Running on QEMU/KVM: Need to translate device names as KVM allocates them regardless of the given device ID")
  ebs_devices = {}

  new_device_names = BlockDevice.translate_device_names(ebs[:devices].keys)
  new_device_names.each do |names|
    new_name = names[1]
    old_name = names[0]
    ebs_devices[new_name] = ebs[:devices][old_name]
  end
  set[:ebs][:devices] = ebs_devices

  skip_chars = new_device_names.size
  ebs[:raids].each do |raid_device, config|
    new_raid_devices = BlockDevice.translate_device_names(config[:disks], skip_chars).map{|names| names[1]}
    set[:ebs][:raids][raid_device][:disks] = new_raid_devices
    skip_chars = new_raid_devices.size
  end
end

include_attribute "ebs::customize"
