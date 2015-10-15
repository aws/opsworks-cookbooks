name              'le'
maintainer        'Logentries'
maintainer_email  'support@logentries.com'
license           'Apache 2.0'
description       'Installs and configures the logentries agent'
long_description  'Installs the Logentries python agent and configures it to follow logs specified in a JSON object'
recipe            'le::default',   'Downloads the agent and sets up logging'
recipe            'le::install',    'Download and install the agent from le repo'
recipe            'le::configure', 'Register and le start agent, follow files'
version           '0.2.6'
source_url        'https://github.com/logentries/le_chef' if respond_to?(:source_url)
issues_url        'https://github.com/logentries/le_chef/issues' if respond_to?(:issues_url)


supports 'ubuntu'
supports 'rhel'

suggests 'java', '~> 1.22'