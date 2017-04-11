service 'resque-scheduler' do
  action [:stop, :start]
  provider Chef::Provider::Service::Upstart
end
