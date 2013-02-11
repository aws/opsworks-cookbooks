#!/usr/bin/env ruby

PASSENGER_STATUS = '/usr/local/bin/passenger-status'

class Array; def sum; inject( nil ) { |sum,x| sum ? sum+x : x }; end; end
class Array; def mean; sum / size; end; end

class Float
  def round_to(i)
    f = (10 ** i).to_f
    nr = self * f
    return nr.round / f
  end
end

data = {
  'max' => 0,
  'count' => 0,
  'active' => 0,
  'inactive' => 0,
  'sessions' => 0,
  'waiting' => 0
}

lines = `#{PASSENGER_STATUS}`
lines.split("\n").each do |line|
  if line.match(/^max/)
    data['max'] = line.split(" ")[2].to_i
  elsif line.match(/^count/)
    data['count'] = line.split(" ")[2].to_i
  elsif line.match(/^active/)
    data['active'] = line.split(" ")[2].to_i
  elsif line.match(/^inactive/)
    data['inactive'] = line.split(" ")[2].to_i
  elsif line.match(/^Waiting on global/)
    data['Waiting'] = line.split(" ").last.to_i
  elsif line.match(/Sessions/)
    data['sessions'] += line.split(" ")[3].to_i
  end
end

puts "Passenger Status"
puts "Max Processes: #{data['max']}"
puts "Current Processes : #{data['count']}"
puts "Active Processes: #{data['active']}"
puts "Inactive Processes: #{data['inactive']}"
puts "Waiting on global queue: #{data['waiting']}"
puts "Sessions: #{data['sessions']}"

`gmetric -tint8 -x60 -n"passenger_max_processes" -v#{data['max']}`
`gmetric -tint8 -x60 -n"passenger_current_processes" -v#{data['count']}`
`gmetric -tint8 -x60 -n"passenger_active_processes" -v#{data['active']}`
`gmetric -tint8 -x60 -n"passenger_inactive_processes" -v#{data['inactive']}`
`gmetric -tint8 -x60 -n"passenger_waiting_processes" -v#{data['waiting']}`
`gmetric -tint8 -x60 -n"passenger_sessions" -v#{data['sessions']}`
