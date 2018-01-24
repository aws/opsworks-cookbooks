package "nvme-cli" do
  not_if { EbsVolumeHelpers.has_ebs_tooling? }
  retries 2
end

node[:ebs][:devices].each do |device, options|
  if options[:mount_point].nil? || options[:mount_point].empty?
    log "skip mounting volume #{device} because no mount_point specified"
    next
  end

  ebs_volume device do
    mount_point options["mount_point"]
    volume_id options["volume_id"]
    device device
    fstype options["fstype"] || "xfs"
  end
end