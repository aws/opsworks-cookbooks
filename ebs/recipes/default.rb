ruby_block "delete_lines_from_fstab" do
  block do
    file = Chef::Util::FileEdit.new("/etc/fstab")
    file.search_file_delete_line("/dev/nvme")
    file.write_file
  end
end

case node[:platform]
when 'debian','ubuntu'
  package "xfsprogs" do
    retries 3
    retry_delay 5
  end
  package "xfsdump" do
    retries 3
    retry_delay 5
  end
  package "xfslibs-dev" do
    retries 3
    retry_delay 5
  end
when 'amazon','fedora'
  # xfsdump is not an Amazon Linux package at this moment.
  package "xfsprogs" do
    retries 3
    retry_delay 5
  end
  package "xfsprogs-devel" do
    retries 3
    retry_delay 5
  end
when 'redhat','centos'
  unless Chef::VersionConstraint.new("~> 6.0").include?(node["platform_version"])
    # RedHat 6 does not provide xfsprogs
    package "xfsprogs" do
      retries 3
      retry_delay 5
    end
    package "xfsprogs-devel" do
      retries 3
      retry_delay 5
    end
  end
end

# VirtIO device name mapping
if BlockDevice.on_kvm?
  cookbook_file '/usr/local/bin/virtio-to-scsi' do
    source 'virtio-to-scsi'
    owner 'root'
    mode 0755
  end

  cookbook_file '/etc/udev/rules.d/65-virtio-to-scsi.rules' do
    source '65-virtio-to-scsi.rules'
    owner 'root'
    mode 0644
  end

  execute 'Reload udev rules' do
    command 'udevadm control --reload-rules'
  end

  execute 'Let udev reprocess devices' do
    command 'udevadm trigger'
  end
end

include_recipe 'ebs::volumes'
unless node[:ebs][:raids].blank?
  include_recipe 'ebs::raids'
end
