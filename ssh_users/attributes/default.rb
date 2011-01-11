require 'etc'

Etc.group do |entry|
  if entry.name == 'scalarium'
    default[:scalarium_gid] = entry.gid
  end
end
