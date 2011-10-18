events_dir = node[:ganglia][:datadir] + '/conf/events.json.d/'
event = events_dir + node[:scalarium][:sent_at].to_s + '_event.json'

template event do
  source 'event.json.erb'
  mode '0644'
  owner 'www-data'
  variables(:scalarium => node[:scalarium])
end

ruby_block 'Create new events.json file for Ganglia' do
  block do
    File.open(node[:ganglia][:datadir] + '/conf/events.json', 'w') do |file|
      file.puts '[' + Dir["#{events_dir}/*.json"].sort.map {|event| File.read(event)}.join(',') + ']'
    end
  end
end