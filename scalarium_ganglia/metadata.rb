maintainer "Peritor GmbH"
maintainer_email "scalarium@peritor.com"
description "Installs Ganglia Server & Client"
version "0.2"
supports "ubuntu"

recipe "scalarium_ganglia::server", "Ganglia server"
recipe "scalarium_ganglia::configure-server", "Reconfigure Ganglia server with correct clients"
recipe "scalarium_ganglia::client", "Ganglia client"
recipe "scalarium_ganglia::configure-client", "Reconfigure Ganglia client with correct server"

recipe "scalarium_ganglia::monitor-memcached", "Monitor Memcached"
recipe "scalarium_ganglia::monitor-mysql", "Monitor MySQL"
recipe "scalarium_ganglia::monitor-fd-and-sockets", "Monitor File Descriptors and Sockets"
recipe "scalarium_ganglia::monitor-disk", "Monitor Disk Stats"
recipe "scalarium_ganglia::monitor-apache", "Monitor Apache Stats"

