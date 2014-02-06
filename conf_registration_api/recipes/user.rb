directory '/home/crs-api' do
  action :create
end

user 'crs-api' do
  home '/home/crs-api'
  shell '/bin/bash'
end

directory '/home/crs-api' do
  owner 'crs-api'
  group 'crs-api'

end