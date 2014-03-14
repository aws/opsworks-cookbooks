directory '/home/godtools' do
  action :create
end

user 'crs-api' do
  home '/home/godtools'
  shell '/bin/bash'
end

directory '/home/crs-api' do
  owner 'godtools'
  group 'godtools'

end