service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action :nothing # only define so that it can be restarted if the config changed
end

template "/etc/haproxy/haproxy.cfg" do
  cookbook "haproxy"
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :run, "bash[reload haproxy]"
end

bash "reload haproxy" do
  code <<-EOH
    iptables -I INPUT -p tcp --dport 80 --syn -j DROP
    iptables -I INPUT -p tcp --dport 443 --syn -j DROP
    sleep 1
    service haproxy reload
    iptables -D INPUT -p tcp --dport 80 --syn -j DROP
    iptables -D INPUT -p tcp --dport 443 --syn -j DROP
  EOH
end

execute "echo 'checking if HAProxy is not running - if so start it'" do
  not_if "pgrep haproxy"
  notifies :start, resources(:service => "haproxy")
end

