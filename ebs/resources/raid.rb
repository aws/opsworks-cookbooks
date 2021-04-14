attribute :fstype, :kind_of => String
attribute :mount_point, :kind_of => String
attribute :raid_device, :kind_of => String
attribute :raid_level, :kind_of => Fixnum
attribute :size, :kind_of => Fixnum
attribute :disks, :kind_of => Array
attribute :volume_ids, :kind_of => Array

actions :create
default_action :create