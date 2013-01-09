directory node[:ganglia][:events_dir] do
  mode 0755
  action :create
  recursive true
  owner node[:ganglia][:web][:apache_user]
end

template "#{node[:ganglia][:events_dir]}/#{node[:scalarium][:sent_at]}_event.json" do
  source 'event.json.erb'
  mode 0644
  owner node[:ganglia][:web][:apache_user]
  variables(:scalarium => node[:scalarium])
end

ruby_block 'Create new events.json file for Ganglia' do
  block do
    ::File.open(node[:ganglia][:datadir] + '/conf/events.json', 'w') do |file|
      file.puts '[' + Dir["#{node[:ganglia][:events_dir]}/*.json"].sort.map {|event| File.read(event)}.join(',') + ']'
    end
  end
end
