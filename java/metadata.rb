maintainer        'Amazon Web Services'
license           'Apache 2.0'
description       'Installs and configures a Java application server'
version           '0.1'

#recipe            'java::tomcat_setup', 'Sets up Tomcat'
#recipe            'java::tomcat_install', 'Installs the Tomcat package'
#recipe            'java::service', 'Handles the Java application server service'
#recipe            'java::context', 'Re-writes the context definition of a Java application'

depends           'apache2'
