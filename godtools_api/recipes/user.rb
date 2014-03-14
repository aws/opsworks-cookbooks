directory '/home/godtools' do
  action :create
end

user 'godtools' do
  home '/home/godtools'
  shell '/bin/bash'
end

directory '/home/godtools' do
  owner 'godtools'
  group 'godtools'

end