attribute :mount_point, :kind_of => String
attribute :volume_id, :kind_of => String
attribute :device, :kind_of => String
attribute :fstype, :kind_of => String

actions :mount
default_action :mount

def initialize(*args)
  super
  @action = :mount
end