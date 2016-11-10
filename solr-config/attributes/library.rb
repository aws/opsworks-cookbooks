default['library']['staging']['solr_version'] = "5.3.2-SNAPSHOT"
default['library']['staging']['path'] = "/opt/solr-#{default['library']['staging']['solr_version']}/server/"
default['library']['staging']['core_name'] = "library"
default['library']['staging']['database_url'] = "library-sg.c6orwgo57rj2.us-east-1.rds.amazonaws.com:5432"
default['library']['staging']['database_name'] = "library_staging"
default['library']['staging']['database_user'] = "librarysg"
default['library']['staging']['database_password'] = "library-sg"
default['library']['staging']['cron_delta_import'] = '*/5 * * * *'
default['library']['staging']['cron_full_import'] = '0 2 * * *'

default['library']['production']['solr_version'] = "5.3.2-SNAPSHOT"
default['library']['production']['path'] = "/opt/solr-#{default['library']['staging']['solr_version']}/server/"
default['library']['production']['core_name'] = "library"
default['library']['production']['database_url'] = "library.c6orwgo57rj2.us-east-1.rds.amazonaws.com"
default['library']['production']['database_name'] = "library_production"
default['library']['production']['database_user'] = "libraryprod"
default['library']['production']['database_password'] = "password"
default['library']['production']['cron_delta_import'] = '*/45 * * * *'
default['library']['production']['cron_full_import'] = '0 2 * * *'


default[:logrotate][:rotate] = 2
default[:logrotate][:dateformat] = false # set to '-%Y%m%d' to have date formatted logs
  

