actions :create, :delete

default_action :create

attribute :application, :kind_of => String, :name_attribute => true
attribute :ssh_wrapper_path, :kind_of => String
attribute :ssh_wrapper_dir, :kind_of => String
attribute :ssh_key_file, :kind_of => String
attribute :ssh_key_dir, :kind_of => String, :default => '/root/.ssh'
attribute :ssh_key_data, :kind_of => String
attribute :owner, :kind_of => String, :default => 'root'
attribute :group, :kind_of => String, :default => 'root'
attribute :sloppy, :kind_of => [TrueClass, FalseClass], :default => false
