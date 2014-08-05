require 'minitest/spec'

describe_recipe 'ebs::raids' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'packages' do
    it 'installs packages for software RAID and volume management' do
      package('mdadm').must_be_installed
      package('lvm2').must_be_installed
    end
  end

  describe 'kernel modules' do
    it 'loads device-mapper' do
      assert system("cat /proc/misc | grep -q device-mapper"), "device-mapper wasn't loaded"
    end

    it 'uses the raid personality' do
      node[:ebs][:raids].each do |_, options|
        assert system("cat /proc/mdstat | grep -q 'Personalities.*[raid#{options[:raid_level]}]'"), "personality raid#{options} isn't used"
      end
    end
  end

  describe 'files' do
    it 'creates mdadm.conf' do
      case node[:platform_family]
      when 'rhel'
        file('/etc/mdadm.conf').must_exist.with(:mode, '644').and(:owner, 'root').and(
             :group, 'root')
      when 'debian'
        file('/etc/mdadm/mdadm.conf').must_exist.with(:mode, '644').and(
             :owner, 'root').and(:group, 'root')
      end
    end

    describe 'rc.local' do
      it 'replaces rc.local with mdadm specific things' do
        file('/etc/rc.local').must_include 'modprobe dm-mod'
        file('/etc/rc.local').must_include 'vgchange -ay'
      end

      it 'will touch /var/lock/subsys/local if it is a RHEL based machine, will not touch the file if it is not' do
        case node[:platform_family]
        when 'rhel'
          file('/etc/rc.local').must_include "/var/lock/subsys/local"
        when 'debian'
          file('/etc/rc.local').wont_include '/var/lock/subsys/local'
        end
      end
    end
  end

  describe 'mount points' do
    it 'mounts LVMs to mount points' do
      node[:ebs][:raids].each do |raid_device, options|
        mount_point = options[:mount_point]
        device = "/dev/mapper/lvm--raid--#{raid_device.match(/\d+/)[0]}-lvm#{raid_device.match(/\d+/)[0]}"

        mount(mount_point, :device => device).must_be_mounted

        file('/proc/mounts').must_include("#{device} #{mount_point} #{options[:fstype]}")
      end
    end
  end
end
