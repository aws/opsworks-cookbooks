# Author:: Guilhem Lettron (<guilhem.lettron@youscribe.com>)
# Cookbook Name:: zabbix-agent
# Recipe:: agent_registration
#
# Apache 2.0
#

connection_info = {
  url: "http://#{zabbix_server['zabbix']['web']['fqdn']}/api_jsonrpc.php",
  user: zabbix_server['zabbix']['web']['login'],
  password: zabbix_server['zabbix']['web']['password']
}

ip_address = node['ipaddress']
if node['zabbix']['agent']['network_interface']
  target_interface = node['zabbix']['agent']['network_interface']
  if node['network']['interfaces'][target_interface]
    ip_address = node['network']['interfaces'][target_interface]['addresses'].keys[1]
    Chef::Log.debug "zabbix::agent_registration : Using ip address of #{ip_address} for host"
  else
    Chef::Log.warn "zabbix::agent_registration : Could not find interface address for #{target_interface}, falling back to default"
  end
end

interface_definitions = {
  zabbix_agent: {
    type: 1,
    main: 1,
    useip: 1,
    ip: ip_address,
    dns: node['fqdn'],
    port: node['zabbix']['agent']['zabbix_agent_port']
  },
  jmx: {
    type: 4,
    main: 1,
    useip: 1,
    ip: ip_address,
    dns: node['fqdn'],
    port: node['zabbix']['agent']['jmx_port']
  },
  snmp: {
    type: 2,
    main: 1,
    useip: 1,
    ip: ip_address,
    dns: node['fqdn'],
    port: node['zabbix']['agent']['snmp_port']
  }
}

interface_list = node['zabbix']['agent']['interfaces']

interface_data = []
interface_list.each do |interface|
  if interface_definitions.key?(interface.to_sym)
    interface_data.push(interface_definitions[interface.to_sym])
  else
    Chef::Log.warn "WARNING: Interface #{interface} is not defined in agent_registration.rb"
  end
end

libzabbix_host node['hostname'] do
  create_missing_groups true
  server_connection connection_info
  parameters(
    host: node['hostname'],
    groupNames: node['zabbix']['agent']['groups'],
    templates: node['zabbix']['agent']['templates'],
    interfaces: interface_data
  )
  action :nothing
end

log 'Delay agent registration to wait for server to be started' do
  level :debug
  notifies :create_or_update, "zabbix_host[#{node['hostname']}]", :delayed
end
