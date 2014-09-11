###
# Do not use this file to override the deploy cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "deploy/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'deploy/attributes/deploy.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'deploy::logrotate'
include_attribute 'deploy::rails_stack'


default[:opsworks][:deploy_user][:shell] = '/bin/bash'
default[:opsworks][:deploy_user][:user] = 'deploy'
default[:opsworks][:deploy_keep_releases] = 5

# The deploy provider used. Set to one of
# - "Branch"      - enables deploy_branch (Chef::Provider::Deploy::Branch)
# - "Revision"    - enables deploy_revision (Chef::Provider::Deploy::Revision)
# - "Timestamped" - enables deploy (default, Chef::Provider::Deploy::Timestamped)
# Deploy provider can also be set at application level.
default[:opsworks][:deploy_chef_provider] = 'Timestamped'

valid_deploy_chef_providers = ['Timestamped', 'Revision', 'Branch']
unless valid_deploy_chef_providers.include?(node[:opsworks][:deploy_chef_provider])
  raise "Invalid deploy_chef_provider: #{node[:opsworks][:deploy_chef_provider]}. Valid providers: #{valid_deploy_chef_providers.join(', ')}."
end

# the $HOME of the deploy user can be overwritten with this variable.
#default[:opsworks][:deploy_user][:home] = '/home/deploy'

case node[:platform]
when 'debian','ubuntu'
  default[:opsworks][:deploy_user][:group] = 'www-data'
when 'centos','redhat','fedora','amazon'
  default[:opsworks][:deploy_user][:group] = node['opsworks']['rails_stack']['name'] == 'nginx_unicorn' ? 'nginx' : 'apache'
end

default[:opsworks][:rails][:ignore_bundler_groups] = ['test', 'development']

default[:deploy] = {}
node[:deploy].each do |application, deploy|
  default[:deploy][application][:deploy_to] = "/srv/www/#{application}"
  default[:deploy][application][:chef_provider] = node[:deploy][application][:chef_provider] ? node[:deploy][application][:chef_provider] : node[:opsworks][:deploy_chef_provider]
  unless valid_deploy_chef_providers.include?(node[:deploy][application][:chef_provider])
    raise "Invalid chef_provider '#{node[:deploy][application][:chef_provider]}' for app '#{application}'. Valid providers: #{valid_deploy_chef_providers.join(', ')}."
  end
  default[:deploy][application][:keep_releases] = node[:deploy][application][:keep_releases] ? node[:deploy][application][:keep_releases] : node[:opsworks][:deploy_keep_releases]
  default[:deploy][application][:current_path] = "#{node[:deploy][application][:deploy_to]}/current"
  default[:deploy][application][:document_root] = ''
  default[:deploy][application][:ignore_bundler_groups] = node[:opsworks][:rails][:ignore_bundler_groups]
  if deploy[:document_root]
    default[:deploy][application][:absolute_document_root] = "#{default[:deploy][application][:current_path]}/#{deploy[:document_root]}/"
  else
    default[:deploy][application][:absolute_document_root] = "#{default[:deploy][application][:current_path]}/"
  end

  if File.exists?('/usr/local/bin/rake')
    # local Ruby rake is installed
    default[:deploy][application][:rake] = '/usr/local/bin/rake'
  else
    # use default Rake/ruby
    default[:deploy][application][:rake] = 'rake'
  end

  default[:deploy][application][:migrate] = false

  if node[:deploy][application][:auto_bundle_on_deploy]
    default[:deploy][application][:migrate_command] = "if [ -f Gemfile ]; then echo 'OpsWorks: Gemfile found - running migration with bundle exec' && /usr/local/bin/bundle exec #{node[:deploy][application][:rake]} db:migrate; else echo 'OpsWorks: no Gemfile - running plain migrations' && #{node[:deploy][application][:rake]} db:migrate; fi"
  else
    default[:deploy][application][:migrate_command] = "#{node[:deploy][application][:rake]} db:migrate"
  end
  default[:deploy][application][:rails_env] = 'production'
  default[:deploy][application][:action] = 'deploy'
  default[:deploy][application][:user] = node[:opsworks][:deploy_user][:user]
  default[:deploy][application][:group] = node[:opsworks][:deploy_user][:group]
  default[:deploy][application][:shell] = node[:opsworks][:deploy_user][:shell]
  default[:deploy][application][:home] = if !node[:opsworks][:deploy_user][:home].nil?
                                           node[:opsworks][:deploy_user][:home]
                                         elsif self[:passwd] && self[:passwd][self[:deploy][application][:user]] && self[:passwd][self[:deploy][application][:user]][:dir]
                                           self[:passwd][self[:deploy][application][:user]][:dir]
                                         else
                                           "/home/#{self[:deploy][application][:user]}"
                                         end
  default[:deploy][application][:sleep_before_restart] = 0
  default[:deploy][application][:stack][:needs_reload] = true
  default[:deploy][application][:enable_submodules] = true
  default[:deploy][application][:shallow_clone] = false
  default[:deploy][application][:delete_cached_copy] = true
  default[:deploy][application][:create_dirs_before_symlink] = ['tmp', 'public', 'config']
  default[:deploy][application][:symlink_before_migrate] = {}
  default[:deploy][application][:symlinks] = {"system" => "public/system", "pids" => "tmp/pids", "log" => "log"}

  default[:deploy][application][:environment] = {"RAILS_ENV" => deploy[:rails_env],
                                                 "RUBYOPT" => "",
                                                 "RACK_ENV" => deploy[:rails_env],
                                                 "HOME" => node[:deploy][application][:home]}
  default[:deploy][application][:environment_variables] = {}
  default[:deploy][application][:ssl_support] = false
  default[:deploy][application][:auto_npm_install_on_deploy] = true

  # nodejs
  default[:deploy][application][:nodejs][:restart_command] = "monit restart node_web_app_#{application}"
  default[:deploy][application][:nodejs][:stop_command] = "monit stop node_web_app_#{application}"
  default[:deploy][application][:nodejs][:port] = deploy[:ssl_support] ? 443 : 80
end

default[:opsworks][:skip_uninstall_of_other_rails_stack] = false

include_attribute "deploy::customize"
