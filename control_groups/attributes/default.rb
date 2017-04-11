
default[:control_groups][:mounts] = {
  :cpu => '/sys/fs/cgroup/cpu',
  :cpuacct => '/sys/fs/cgroup/cpuacct',
  :devices => '/sys/fs/cgroup/devices',
  :memory => '/sys/fs/cgroup/memory',
  :freezer => '/sys/fs/cgroup/freezer'
}
