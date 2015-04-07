actions :create, :delete
default_action :create

attribute :user, :kind_of => String
attribute :command, :kind_of => String
attribute :controllers, :kind_of => Array, :required => true
attribute :destination, :kind_of => String, :required => true
