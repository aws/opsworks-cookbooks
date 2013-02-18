service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action :nothing
end