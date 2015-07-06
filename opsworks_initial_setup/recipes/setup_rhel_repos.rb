if node[:platform] == 'amazon'
  # We only have to run 'yum-config-manager --quiet --enable epel' in order
  # to get EPEL working. Handle EPEL as optional as it may have
  # availability problems and we do not want it to effect built-in cookbooks
  execute 'yum-config-manager --quiet --enable epel && yum-config-manager --save --setopt=epel.skip_if_unavailable=true' do
    not_if "yum-config-manager epel | grep 'enabled = True'"
  end
end
