package 'supervisor' do
  action :install
end

template "/etc/supervisor/conf.d/legacy_consumers.conf" do
  source "legacy_consumers.rb"
end

execute '/etc/init.d/supervisor restart'
