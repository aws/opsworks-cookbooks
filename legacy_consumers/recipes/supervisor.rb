node[:deploy].each do |app_name, deploy|

  package 'supervisor' do
    action :install
  end

  template "/etc/supervisor/conf.d/legacy_consumers.conf" do
    source "legacy_consumers.rb"
    variables({ :user => deploy[:user] })
  end

  execute '/etc/init.d/supervisor restart'
end
