user 'catalogoeditorial' do
  supports :manage_home => true
  comment 'Catalogo Editorial User'
  gid 'users'
  home '/home/catalogoeditorial'
  shell '/bin/false'
  password '$1$IbK0KxRL$pnXrASwzWwPRvyNdEpWmm1'
end

execute 'usermod -g users deploy'
