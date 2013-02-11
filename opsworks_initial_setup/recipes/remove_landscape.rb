# removes landscape as it is not used, it makes login slower and sometimes even timing it out
# e.g. http://askubuntu.com/questions/86057/ssh-hangs-about-a-minute-after-login/162373#162373

node[:opsworks_initial_setup][:landscape][:packages_to_remove].each do |pkg|
  package pkg do
    action :purge
  end
end
