service 'gmetad' do
  supports :status => false, :restart => true
  action :nothing
end
