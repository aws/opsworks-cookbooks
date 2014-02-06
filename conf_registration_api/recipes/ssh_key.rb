directory '/home/crs-api/.ssh' do
  mode 0700
  owner 'crs-api'
  group 'crs-api'

  action :create
end

template '/home/crs-api/.ssh/id_rsa' do
  mode 0700
  owner 'crs-api'
  group 'crs-api'
  source 'ssh_key.erb'

  action :create_if_missing
end