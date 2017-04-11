node[:deploy].each do |app_name, deploy|

  package 'supervisor' do
    action :install
  end

  template "/etc/supervisor/conf.d/legacy_consumers.conf" do
    source "legacy_consumers.rb"
    variables({ :user => deploy[:user],
                :target => "#{deploy[:deploy_to]}/current" })
  end

  execute '/etc/init.d/supervisor restart'
end
