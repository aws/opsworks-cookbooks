module BlockDevice
  def self.wait_for(device, timeout = 300)
    sleep_time = 10
    time_elapsed = 0

    while time_elapsed <= timeout
      if File.blockdev?(device)
        Chef::Log.info("device #{device} ready")
        break
      else
        Chef::Log.info("device #{device} not ready - waiting")
        sleep sleep_time
        time_elapsed += sleep_time
      end
    end

    Chef::Log.info("Waiting for device #{device} becoming ready timed out.") if time_elapsed > timeout
  end

  def self.wait_for_logical_volumes(timeout = 300)
    sleep_time = 10
    time_elapsed = 0

    while time_elapsed <= timeout
      begin
        lvscan = OpsWorks::ShellOut.shellout("lvscan")
        if lvscan.gsub(/^$\n/, "").lines.all?{|line| line.include?('ACTIVE')}
          Chef::Log.debug("All LVM volume disks seem to be active:\n#{lvscan}")
          Chef::Log.info("All LVM volume disks seem to be active")
          break
        else
          Chef::Log.debug("Not all LVM volume disks seem to be active, waiting #{sleep_time} more seconds:\n#{lvscan}")
          Chef::Log.info("Not all LVM volume disks seem to be active, waiting #{sleep_time} more seconds")
          sleep sleep_time
          time_elapsed += sleep_time
          begin
            vgchange_status = OpsWorks::ShellOut.shellout("vgchange -ay")
            Chef::Log.debug("Tried to activate all local volume groups:\n#{vgchange_status}")
            Chef::Log.info("Tried to activate all local volume groups")
          rescue RuntimeError => e
            Chef::Log.debug("Activation of all local volume groups failed: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
            Chef::Log.info("Activation of all local volume groups failed: #{e.message}")
          end
        end
      rescue RuntimeError => e
        Chef::Log.debug("Scanning LVM volume disks failed: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
        Chef::Log.info("Scanning LVM volume disks failed (retrying in #{sleep_time} seconds): #{e.message}")
        sleep sleep_time
        time_elapsed += sleep_time
      end
    end

    Chef::Log.info("Waiting for all LVM volume disks becoming active timed out.") if time_elapsed > timeout
  end

  def self.existing_raid_at?(device)
    raids = OpsWorks::ShellOut.shellout("mdadm --examine --scan")
    if raids.match(device) || raids.match(device.gsub(/md/, "md/"))
      Chef::Log.debug("Checking for existing RAID arrays at #{device}: #{raids}")
      Chef::Log.info("Checking for existing RAID arrays at #{device}: true")
      true
    else
      Chef::Log.debug("Checking for existing RAID arrays at #{device}: #{raids}")
      Chef::Log.info("Checking for existing RAID arrays at #{device}: false")
      false
    end
  rescue RuntimeError => e
    Chef::Log.debug("Checking for existing RAID arrays failed: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
    Chef::Log.info("Checking for existing RAID arrays failed: #{e.message}")
    false
  end

  def self.assembled_raid_at?(device)
    raids = OpsWorks::ShellOut.shellout("mdadm --detail --scan")
    if raids.match(device)
      Chef::Log.debug("Checking for running RAID arrays at #{device}: #{raids}")
      Chef::Log.info("Checking for running RAID arrays at #{device}: true")
      clean_raid_at?(device)
    else
      Chef::Log.debug("Checking for running RAID arrays at #{device}: #{raids}")
      Chef::Log.info("Checking for running RAID arrays at #{device}: false")
      false
    end
  rescue RuntimeError => e
    Chef::Log.debug("Checking for running RAID arrays failed: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
    Chef::Log.info("Checking for running RAID arrays failed: #{e.message}")
    false
  end

  def self.clean_raid_at?(raid_device)
    OpsWorks::ShellOut.shellout("mdadm --detail --test #{raid_device} > /dev/null")
    Chef::Log.info("RAID array at #{raid_device} is clean")
    true
  rescue RuntimeError => e
    Chef::Log.debug("RAID array at #{raid_device} is not clean: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
    Chef::Log.info("RAID array at #{raid_device} is not clean: #{e.message}")
    false
  end

  def self.assemble_raid(raid_device, options)
    Chef::Log.info("Resuming existing RAID array #{raid_device} with #{options[:disks].size} disks, RAID level #{options[:raid_level]} at #{options[:mount_point]}")
    unless exec_command("mdadm --assemble --verbose #{raid_device} #{options[:disks].join(' ')}")
      plain_disks = options[:disks].map{|disk| disk.gsub('/dev/', '')}
      affected_volume_groups = []
      File.readlines('/proc/mdstat').each do |line|
        md_device = nil
        md_device = line.split.first if plain_disks.any?{|disk| line.include?(disk)}
        if md_device
          begin
            physical_volume_info = OpsWorks::ShellOut.shellout("pvdisplay -c /dev/#{md_device}").lines.grep(%r{/dev/#{md_device}}).first
            if physical_volume_info
              volume_group = physical_volume_info.split(':')[1] rescue nil
              if volume_group
                affected_volume_groups << volume_group
                Chef::Log.info("Deactivating volume group #{volume_group}")
                exec_command("vgchange --available n #{volume_group}")
              end
            end
          rescue RuntimeError => e
            Chef::Log.debug("Getting attributes of /dev/#{md_device} failed: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
            Chef::Log.info("Getting attributes of /dev/#{md_device} failed: #{e.message}")
          ensure
            Chef::Log.info("Stopping /dev/#{md_device}")
            exec_command("mdadm --stop --verbose /dev/#{md_device}")
          end
        end
      end
      exec_command("mdadm --assemble --verbose #{raid_device} #{options[:disks].join(' ')}") or raise "Failed to assemble the RAID array at #{raid_device}"
      affected_volume_groups.each do |volume_group|
        Chef::Log.info "(Re-)activating volume group #{volume_group}"
        exec_command("vgchange --available y #{volume_group}")
      end
    end
  end

  def self.create_raid(raid_device, options)
    Chef::Log.info "creating RAID array #{raid_device} with #{options[:disks].size} disks, RAID level #{options[:raid_level]} at #{options[:mount_point]}"
    exec_command("yes n | mdadm --create --chunk=#{options[:chunk_size]} --metadata=1.2 --verbose #{raid_device} --level=#{options[:raid_level]} --raid-devices=#{options[:disks].size} #{options[:disks].join(' ')}") or raise "Failed to create the RAID array at #{raid_device}"
  end

  def self.set_read_ahead(raid_device, ahead_option)
    Chef::Log.info "Setting read ahead options for RAID array #{raid_device} to #{ahead_option}"
    exec_command("blockdev --setra #{ahead_option} #{raid_device}") or raise "Failed to set read ahead options for RAID array at #{raid_device} to #{ahead_option}"
  end

  def self.lvm_device(raid_device)
    "/dev/#{lvm_volume_group(raid_device)}/lvm#{raid_device.match(/\d+/)[0]}"
  end

  def self.lvm_volume_group(raid_device)
    "lvm-raid-#{raid_device.match(/\d+/)[0]}"
  end

  def self.existing_lvm_at?(lvm_device)
    lvms = OpsWorks::ShellOut.shellout("lvscan")
    if lvms.match(lvm_device)
      Chef::Log.debug("Checking for active LVM volumes at #{lvm_device}: #{lvms}")
      Chef::Log.info("Checking for active LVM volumes at #{lvm_device}: true")
      true
    else
      Chef::Log.debug("Checking for active LVM volumes at #{lvm_device}: #{lvms}")
      Chef::Log.info("Checking for active LVM volumes at #{lvm_device}: false")
      false
    end
  rescue RuntimeError => e
    Chef::Log.debug("Checking for active LVM volumes failed: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
    Chef::Log.info("Checking for active LVM volumes failed: #{e.message}")
    false
  end

  def self.create_lvm(raid_device, options)
    Chef::Log.info "creating LVM volume out of #{raid_device} with #{options[:disks].size} disks at #{options[:mount_point]}"
    unless lvm_physical_group_exists?(raid_device)
      exec_command("pvcreate #{raid_device}") or raise "Failed to create LVM physical disk for #{raid_device}"
    end
    unless lvm_volume_group_exists?(raid_device)
      exec_command("vgcreate #{lvm_volume_group(raid_device)} #{raid_device}") or raise "Failed to create LVM volume group for #{raid_device}"
    end
    unless lvm_volume_exits?(raid_device)
      unless exec_command_with_retries("lvcreate -l 100%FREE #{lvm_volume_group(raid_device)} -n #{File.basename(lvm_device(raid_device))}")
        exec_command("lvcreate -l 100%FREE #{lvm_volume_group(raid_device)} -n #{File.basename(lvm_device(raid_device))} -Z n") or raise "Failed to create the LVM volume at #{raid_device}"
      end
    end
  end

  def self.lvm_physical_group_exists?(raid_device)
    pvscan = OpsWorks::ShellOut.shellout("pvscan")
    if pvscan.match(raid_device)
      Chef::Log.debug("Checking for existing LVM physical disk for #{raid_device}: #{pvscan}")
      Chef::Log.info("Checking for existing LVM physical disk for #{raid_device}: true")
      true
    else
      Chef::Log.debug("Checking for existing LVM physical disk for #{raid_device}: #{pvscan}")
      Chef::Log.info("Checking for existing LVM physical disk for #{raid_device}: false")
      false
    end
  rescue RuntimeError => e
    Chef::Log.debug("Checking for existing LVM physical disk failed: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
    Chef::Log.info("Checking for existing LVM physical disk failed: #{e.message}")
    false
  end

  def self.lvm_volume_group_exists?(raid_device)
    vgscan = OpsWorks::ShellOut.shellout("vgscan")
    if vgscan.match(lvm_volume_group(raid_device))
      Chef::Log.debug("Checking for existing LVM volume group for #{lvm_volume_group(raid_device)}: #{vgscan}")
      Chef::Log.info("Checking for existing LVM volume group for #{lvm_volume_group(raid_device)}: true")
      true
    else
      Chef::Log.debug("Checking for existing LVM volume group for #{lvm_volume_group(raid_device)}: #{vgscan}")
      Chef::Log.info("Checking for existing LVM volume group for #{lvm_volume_group(raid_device)}: false")
      false
    end
  rescue RuntimeError => e
    Chef::Log.debug("Checking for existing LVM volume group failed: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
    Chef::Log.info("Checking for existing LVM volume group failed: #{e.message}")
    false
  end

  def self.lvm_volume_exits?(raid_device)
    wait_for_logical_volumes
    lvscan = OpsWorks::ShellOut.shellout("lvscan")
    if lvscan.match(lvm_device(raid_device))
      Chef::Log.debug("Checking for existing LVM volume disk for #{lvm_device(raid_device)}: #{lvscan}")
      Chef::Log.info("Checking for existing LVM volume disk for #{lvm_device(raid_device)}: true")
      true
    else
      Chef::Log.debug("Checking for existing LVM volume disk for #{lvm_device(raid_device)}: #{lvscan}")
      Chef::Log.info("Checking for existing LVM volume disk for #{lvm_device(raid_device)}: false")
      false
    end
  rescue RuntimeError => e
      Chef::Log.debug("Checking for existing LVM volume disk failed: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
      Chef::Log.info("Checking for existing LVM volume disk failed: #{e.message}")
    false
  end

  def self.exec_command(command)
    Chef::Log.debug("Executing: #{command}")
    cmd = Mixlib::ShellOut.new(command)
    cmd.run_command
    Chef::Log.info([cmd.stderr, cmd.stdout].join("\n"))
    Chef::Log.debug("'#{command}' returned #{cmd.exitstatus}")
    !cmd.error?
  rescue Errno::EACCES
    Chef::Log.fatal("Permission denied on '#{command}'")
    false
  rescue Errno::ENOENT
    Chef::Log.fatal("Command not found: '#{command}'")
    false
  rescue Chef::Exceptions::CommandTimeout
    Chef::Log.fatal("Commaned timed out: '#{command}'")
    false
  end

  def self.exec_command_with_retries(command, max_tries=3, exponential_sleep_time_factor=10)
    try_count = 1
    while try_count <= max_tries
      Chef::Log.info("Try #{try_count}/#{max_tries}: #{command}")
      break if exec_command(command)
      sleep_time = exponential_sleep_time_factor * (2 ** (try_count - 1))
      Chef::Log.info("Try #{try_count}/#{max_tries} for '#{command}' failed - retrying in #{sleep_time} seconds.")
      sleep sleep_time
      try_count += 1
    end
    success = try_count <= max_tries
    Chef::Log.info("'#{command}' successful after #{try_count}/#{max_tries} tries? #{success}")
    success
  end

  def self.translate_device_names(devices, skip = 0)
    if on_kvm? && devices.size > 0
      Chef::Log.info("Running on QEMU/KVM: Starting at /dev/sdb skipping #{skip}")
      new_devices = ('b'..'z').to_a[0 + skip, devices.size].each_with_index.map {|char, index| [ devices[index], "/dev/sd#{char}" ]  }
      Chef::Log.info("Running on QEMU/KVM: Translated EBS devices #{devices.inspect} to #{new_devices.map{|d| d[1]}.inspect}")
      new_devices
    else
      devices
    end
  end

  def self.on_kvm?
    File.read("/proc/cpuinfo").match(/QEMU/)
  end
end
