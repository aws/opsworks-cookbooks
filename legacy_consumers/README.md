Description
===========

The `deploy_wrapper` cookbook provides a lightweight resource provider which sets up an ssh key and ssh wrapper script for
use with `deploy` or `deploy_revision` resources.

Attributes
==========

* `ssh_wrapper_path` - final path for your ssh wrapper script.
* `ssh_wrapper_dir` - the ssh wrapper script will be written to this directory.
* `ssh_key_file` - key file to use.
* `ssh_key_dir` - the ssh key file will be written to this directory.
* `ssh_key_data` - the private key data to write into the ssh key file, this override `ssh_key_file`.
* `owner` - the owner for ssh wrapper and key files, defaults to 'root'
* `group` - the group ownership for ssh wrapper and key files, defaults to 'root'
* `sloppy` - a boolean which toggles whether or not the ssh wrapper script will attempt to validate the repo's ssh key. This parameter defaults to `false`, but the default setting will probably cause problems when executing deploy resources if `~/.ssh/known_hosts` has not been pre-populated manually or via another cookbook.

Platform
========

Should work on any platform where Chef runs. Tested on Ubuntu.

Requirements
============

N/A

Usage example
=============

    include_recipe 'deploy_wrapper'

    deploy_wrapper 'myapp' do
        owner 'root'
        group 'root'
        ssh_wrapper_dir '/opt/example/shared'
        ssh_key_dir '/root/.ssh'
        ssh_key_data secrets['deploy_keys']['myapp']
        sloppy true
    end

    deploy_revision '/opt/example/myapp' do
        revision 'master'
        repo 'https://github.com/example/myapp'
        ssh_wrapper '/opt/example/shared/myapp_deploy_wrapper.sh'
    end

License and Author
==================

Author:: Cameron Johnston <cameron@rootdown.net>
Author:: Guilhem Lettron <guilhem@lettron.fr>

Copyright:: 2012, Cameron Johnston

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
