template '/etc/yum.conf' do
  source 'yum.conf.erb'
  mode 0444
  owner 'root'
  group 'root'
end
