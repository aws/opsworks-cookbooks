name             "opsworks_delayed_job"
maintainer       "Artsy"
maintainer_email "it@artsymail.com"
license          "MIT"
description      "Configure and deploy background job workers."
version          "0.6"

recipe 'opsworks_delayed_job::setup', 'Set up delayed_job worker.'
recipe 'opsworks_delayed_job::configure', 'Configure delayed_job worker.'
recipe 'opsworks_delayed_job::deploy', 'Deploy delayed_job worker.'
recipe 'opsworks_delayed_job::undeploy', 'Undeploy delayed_job worker.'
recipe 'opsworks_delayed_job::stop', 'Stop delayed_job worker.'

depends 'deploy'
