actions :create
default_action :create

attribute :application, :kind_of => String, :required => true
attribute :deploy_to, :kind_of => String, :required => true
attribute :rails_env, :kind_of => String, :required => true
attribute :user, :kind_of => String, :required => true
attribute :group, :kind_of => String, :required => true

attribute :database_data, :kind_of => Hash, :required => true
attribute :memcached_data, :kind_of => Hash, :required => true

attribute :restart, :kind_of => [TrueClass, FalseClass], :default => false
