# Add Monit configuration file via the `monitrc` definition
#
begin
  monitrc "elasticsearch" do
    template_cookbook "elasticsearch"
    template_source   "elasticsearch.monitrc.conf.erb"
    source            "elasticsearch.monitrc.conf.erb"
  end
rescue Exception => e
  Chef::Log.error "The 'monit' recipe is not included in the node run_list or the 'monitrc' resource is not defined"
  raise e
end

# NOTE: On some systems, notably Amazon Linux, Monit installed from packages
#       has a different configuration file then expected by the Monit
#       cookbook. In such case:
#
#       sudo cp /etc/monit/monitrc /etc/monit.conf
