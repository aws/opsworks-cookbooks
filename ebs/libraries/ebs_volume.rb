module EbsVolumeHelpers

  def self.nvme_based?
    diskstats = File.read("/proc/diskstats")

    # this is true on C5 and M5 instance but not on I3 instances which
    # have a special on-instance ssd attached via NVMe, I3 should be
    # handled like previously, whereas C5 and M5 should be handled via
    # nvme tooling
    diskstats.match(%r(nvme)) && !diskstats.match(%r(xvda))
  end

  def self.has_ebs_tooling?
    File.executable?("/sbin/ebsnvme-id")
  end

  def self.volume_id(device_name)
    if self.has_ebs_tooling?
      cmd = Mixlib::ShellOut.new("/sbin/ebsnvme-id #{device_name}")
      cmd.run_command

      if !Array(cmd.valid_exit_codes).include?(cmd.exitstatus)
        if cmd.stderr =~ /Not an EBS device/
          return nil
        else
          cmd.error!
        end
      end

      # example output:
      #   Volume ID: vol-03ad072723a6e3595
      #   xvda
      cmd.stdout.lines.first.split(':')[1].strip
    else
      cmd = Mixlib::ShellOut.new("/usr/sbin/nvme id-ctrl #{device_name}")
      cmd.run_command
      cmd.error!

      # example output:
      #   NVME Identify Controller:
      #   vid     : 0x1d0f
      #   ssvid   : 0x1d0f
      #   sn      : vol03ad072723a6e3595
      #   mn      : Amazon Elastic Block Store
      #   fr      : 1.0
      #   rab     : 32
      #   ieee    : dc02a0
      #   cmic    : 0
      map = Hash[cmd.stdout.lines.map { |l| l.split(':', 2).map(&:strip) }]

      return nil unless /Amazon Elastic Block/.match(map["mn"])

      map["sn"].gsub(/^vol/, "vol-")
    end
  end

  def self.device_name(volume_id)
    known_nvme_disks = File.read("/proc/diskstats").lines.map do |line|
      m = line.match(/(nvme[0-9]{1,2}n1)/)
      if m
        m[1]
      else
        nil
      end
    end
    attached_nvme_volumes = Hash[known_nvme_disks.compact.map do |d|
      device_path = "/dev/#{d}"
      ebs_volume_id = EbsVolumeHelpers.volume_id(device_path)
      if ebs_volume_id.nil?
        nil
      else
        [ebs_volume_id, device_path]
      end
    end.compact]

    device_name = attached_nvme_volumes[volume_id]
    raise "Cannot find device for EBS volume id #{volume_id}, known devices: #{attached_nvme_volumes}" if device_name.nil?

    device_name
  end
end