default[:haproxy] = {}
default[:haproxy][:stats_url] = '/haproxy?stats'
default[:haproxy][:stats_user] = 'scalarium'
default[:haproxy][:health_check_url] = '/'
default[:haproxy][:health_check_method] = 'OPTIONS'
default[:haproxy][:check_interval] = '10s'
default[:haproxy][:client_timeout] = '60s'
default[:haproxy][:server_timeout] = '60s'
default[:haproxy][:queue_timeout] = '120s'
default[:haproxy][:connect_timeout] = '10s'
default[:haproxy][:http_request_timeout] = '30s'
default[:haproxy][:global_max_connections] = '10000'
default[:haproxy][:default_max_connections] = '9600'
default[:haproxy][:retries] = '3'

def random_haproxy_pw
  rand_array = []
  "a".upto("z"){|e| rand_array << e}
  1.upto(9){|e| rand_array << e.to_s}

  pw = ""
  10.times do
    pw += (rand_array[rand(rand_array.size) - 1])
  end
  pw
end

default[:haproxy][:stats_password] = random_haproxy_pw
default[:haproxy][:enable_stats] = false