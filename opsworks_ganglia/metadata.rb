maintainer "Amazon Web Services"
version "0.2"
supports "ubuntu"

recipe "opsworks_ganglia::server", "Ganglia server"
recipe "opsworks_ganglia::configure-server", "Reconfigure Ganglia server with correct clients"
recipe "opsworks_ganglia::client", "Ganglia client"
recipe "opsworks_ganglia::configure-client", "Reconfigure Ganglia client with correct server"

recipe "opsworks_ganglia::monitor-memcached", "Monitor Memcached"
recipe "opsworks_ganglia::monitor-mysql", "Monitor MySQL"
recipe "opsworks_ganglia::monitor-fd-and-sockets", "Monitor File Descriptors and Sockets"
recipe "opsworks_ganglia::monitor-disk", "Monitor Disk Stats"
recipe "opsworks_ganglia::monitor-apache", "Monitor Apache Stats"

depends 'apache2'
depends 'opsworks_commons'
