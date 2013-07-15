require 'minitest/spec'

describe_recipe 'ebs::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  describe 'packages' do
    it 'should install xfs packages' do
      package('xfsprogs').must_be_installed
      case node[:platform_family]
      when 'debian'
        package('xfsdump').must_be_installed
        package('xfslibs-dev').must_be_installed
      when 'rhel'
        package('xfsprogs-devel').must_be_installed
      end
    end
  end

  if BlockDevice.on_kvm?
    describe 'KVM setup' do
      it 'creates /usr/local/bin/virtio-to-scsi' do
          file('/usr/local/bin/virtio-to-scsi').must_exist.with(:owner, 'root').and(:mode, '755')
      end

      it 'creates udev rules' do
          file('/etc/udev/rules.d/65-virtio-to-scsi.rules').must_exist.with(:owner, 'root').and(:mode, '644')
      end
    end
  end
end
