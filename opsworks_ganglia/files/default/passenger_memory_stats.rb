#!/usr/bin/env ruby

PASSENGER_MEMROY_STATS = '/usr/local/bin/passenger-memory-stats'

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
  'total' => 0,
  'processes' => 0,
  'rails_memory' => []
}

lines = `#{PASSENGER_MEMROY_STATS}`
lines.gsub!(/^.*Passenger processes/m, '')
lines.split("\n").each do |line|
  if line.match(/Total private/)
    data['total'] = line.split(" ")[5].to_f.round_to(2)
  elsif line.match(/Processes/)
    data['processes'] = line.split(" ")[2].to_i
  elsif line.match(/Rails/)
    data['rails_memory'] << line.split(' ')[3].to_f.round_to(2)
  end
end

data['avg_rails_memory'] = data['rails_memory'].mean.to_f.round_to(2) rescue 0

puts "Passenger Memory Stats"
puts "Total Memory: #{data['total']} MB"
puts "Processes : #{data['processes']}"
puts "Average Rails Memory: #{data['avg_rails_memory']} MB"

`gmetric -tint32 -x60 -uMegabytes -n"passenger_total_memory" -v#{data['total']}`
`gmetric -tint32 -x60 -uMegabytes -n"passenger_avg_memory" -v#{data['avg_rails_memory']}`
`gmetric -tint8 -x60 -n"passenger_processes" -v#{data['processes']}`
