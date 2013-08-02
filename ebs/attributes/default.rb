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
