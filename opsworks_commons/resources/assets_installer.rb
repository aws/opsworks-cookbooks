actions :install
default_action :install

attribute :name, :kind_of => String, :required => true

# package naming parameters
attribute :asset, :kind_of => String, :required => true
attribute :version, :kind_of => String, :required => true
attribute :release, :kind_of => String, :default => '1'

# downloader parameters
attribute :max_fetch_retries, :kind_of => Fixnum, :default => 3
