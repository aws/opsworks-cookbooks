if node[:platform] == 'amazon'
  # We only have to run 'yum-config-manager --quiet --enable epel' in order
  # to get EPEL working.
  execute 'yum-config-manager --quiet --enable epel' do
    not_if "yum-config-manager epel | grep 'enabled = True'"
  end
end
