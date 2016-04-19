require 'serverspec'

set :backend, :exec
set :path, '/sbin:/bin:/usr/sbin:/usr/bin:$PATH'
set :env, :LANG => 'C', :LC_MESSAGES => 'C'
