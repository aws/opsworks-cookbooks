actions :create, :delete
default_action :create

attribute :group, :kind_of => String
attribute :perm_task_uid, :kind_of => String
attribute :perm_task_gid, :kind_of => String
attribute :perm_admin_uid, :kind_of => String
attribute :perm_admin_gid, :kind_of => String
attribute :cpu, :kind_of => Hash
attribute :cpuacct, :kind_of => Hash
attribute :devices, :kind_of => Hash
attribute :freezer, :kind_of => Hash
attribute :memory, :kind_of => Hash
attribute :extra_config, :kind_of => Hash
