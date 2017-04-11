# Encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
require 'fauxhai'

LOG_LEVEL = :fatal
SUSE_OPTS = {
  :platform => 'suse',
  :version => '11.3',
  :log_level => LOG_LEVEL
}
REDHAT_OPTS = {
  :platform => 'redhat',
  :version => '6.5',
  :log_level => LOG_LEVEL
}
UBUNTU_OPTS = {
  :platform => 'ubuntu',
  :version => '14.04',
  :log_level => LOG_LEVEL
}
CENTOS_OPTS = {
  :platform => 'centos',
  :version => '6.5',
  :log_level => LOG_LEVEL
}
