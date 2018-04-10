execute 'nvme-cli-ubuntu-14-ppa' do
  command 'add-apt-repository ppa:sbates && apt-get update'
  only_if { EbsVolumeHelpers.nvme_based? && !EbsVolumeHelpers.has_ebs_tooling? && platform?("ubuntu") && node[:platform_version] == "14.04" && node[:ebs][:devices].size != 0 }
end

package "nvme-cli" do
  only_if { EbsVolumeHelpers.nvme_based? && !EbsVolumeHelpers.has_ebs_tooling? && node[:ebs][:devices].size != 0 }
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
