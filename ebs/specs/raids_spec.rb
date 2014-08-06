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
    it 'loads dm_mod module into memory' do
      assert system('lsmod | grep dm_mod'), 'dm_mod wasn\'t loaded into memory'
    end
  end

  describe 'files' do
    it 'creates mdadm.conf' do
      case node[:platform]
      when 'centos','redhat','fedora','amazon'
        file('/etc/mdadm.conf').must_exist.with(:mode, '644').and(:owner, 'root').and(
             :group, 'root')
      else
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
        case node[:platform]
        when 'debian','ubuntu'
          file('/etc/rc.local').wont_include '/var/lock/subsys/local'
        when 'centos','redhat','fedora','amazon'
          file('/etc/rc.local').must_include "/var/lock/subsys/local"
        end
      end
    end
  end

  describe 'mount points' do
    it 'mounts /dev/lvm-raid-[0-9]*/lvm[0-9]* to mount point' do
      node[:ebs][:raids].each do |raid_device, options|
        mount(options[:mount_point],
              :device => "/dev/lvm-raid-#{raid_device.match(/\d+/)[0]}/lvm#{raid_device.match(/\d+/)[0]}").must_be_mounted.with(:fstype, options[:fstype])
      end
    end
  end
end
