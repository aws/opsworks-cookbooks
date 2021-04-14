package "mdadm" do
  retries 3
  retry_delay 5
end

package "lvm2" do
  retries 3
  retry_delay 5
end
require "mkmf"

execute 'nvme-cli-ubuntu-14-ppa' do
  command 'add-apt-repository ppa:sbates && apt-get update'
  only_if { EbsVolumeHelpers.nvme_based? && !EbsVolumeHelpers.has_ebs_tooling? && platform?("ubuntu") && node[:platform_version] == "14.04" && node[:ebs][:raids].size != 0 }
end

package "nvme-cli" do
  only_if { EbsVolumeHelpers.nvme_based? && !EbsVolumeHelpers.has_ebs_tooling? && node[:ebs][:raids].size != 0 }
  retries 2
end

execute 'Load device mapper kernel module' do
  command 'modprobe dm-mod'
  ignore_failure true
end

node.set[:ebs][:raids].each do |raid_device, options|
  ebs_raid raid_device do
    fstype options[:fstype]
    mount_point options[:mount_point]
    raid_device raid_device
    raid_level options[:raid_level]
    size options[:size]
    disks options[:disks]
    volume_ids options[:volume_ids]
  end
end
