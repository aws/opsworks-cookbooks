events_dir = node[:ganglia][:datadir] + '/conf/events.json.d'
event = events_dir + node[:scalarium][:sent_at].to_s + '_event.json'

directory events_dir do
  mode '0755'
  action :create
  recursive true
  user 'www-data'
end

template event do
  source 'event.json.erb'
  mode '0644'
  user 'www-data'
  variables(:scalarium => node[:scalarium])
end

ruby_block 'Create new events.json file for Ganglia' do
  block do
    logs = Dir.glob(events_dir + '/*.json').sort
    logs.each do |log|
      Chef::Log.info("processing #{log}")
    end
  end
end