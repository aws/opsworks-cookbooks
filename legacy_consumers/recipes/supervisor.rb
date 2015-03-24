package 'supervisor' do
  action :install
end

template "/etc/supervisor/conf.d/" do
  source "supervisor.rb"
end
