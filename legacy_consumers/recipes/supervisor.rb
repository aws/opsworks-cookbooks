include_recipe 'supervisor'

supervisor_service "legacy_consumers" do
    command "cd /opt/legacy_consumers/current&& bundle rake"
    autostart true
    autorestart true
    numprocs 1
    process_name "legacy_consumers-%(process_num)s"
end
