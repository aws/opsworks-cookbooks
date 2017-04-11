name 'zabbix-agent'
maintainer 'Bill Warner'
maintainer_email 'bill.warner@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures Zabbix Agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.13.0'

# tested on ubuntu 10.04 12.04 and 14.04
supports 'ubuntu', '>= 10.04'
# tested on centos 6.6 and 7.0
supports 'centos', '>= 6.6'
# tested on debian 6.0.10 and 7.0
supports 'debian', '>= 6.0.10'

# change the needed recommends to depends below
depends 'apt'             # For Debian family OSs
depends 'yum'             # For Redhat family OSs
depends 'build-essential' # for source build/install
depends 'chocolatey'      # For Windows family OSs
recommends 'libzabbix'    # LWRPs to connect to zabbix server
