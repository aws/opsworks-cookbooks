service "monit" do
  supports :status => false, :restart => true, :reload => true
  action [:enable, :nothing]
end
