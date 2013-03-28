include_attribute 'deploy::logrotate'
include_attribute 'deploy::rails_stack'

default[:opsworks][:deploy_user][:shell] = '/bin/bash'
default[:opsworks][:deploy_user][:user] = 'deploy'
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
  default[:deploy][application][:release] = Time.now.utc.strftime("%Y%m%d%H%M%S")
  default[:deploy][application][:release_path] = "#{node[:deploy][application][:deploy_to]}/releases/#{node[:deploy][application][:release]}"
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
  home = self[:passwd] && 
         self[:passwd][self[:deploy][application][:user]] &&
         self[:passwd][self[:deploy][application][:user]][:dir] || "/home/#{self[:deploy][application][:user]}"

  default[:deploy][application][:home] = home

  default[:deploy][application][:sleep_before_restart] = 0
  default[:deploy][application][:stack][:needs_reload] = true
  default[:deploy][application][:enable_submodules] = true
  default[:deploy][application][:shallow_clone] = false
  default[:deploy][application][:delete_cached_copy] = true
  default[:deploy][application][:symlink_before_migrate] = {}
  
  default[:deploy][application][:environment] = {"RAILS_ENV" => deploy[:rails_env],
                                                 "RUBYOPT" => "",
                                                 "RACK_ENV" => deploy[:rails_env],
                                                 "HOME" => home}
  default[:deploy][application][:ssl_support] = false
  default[:deploy][application][:auto_npm_install_on_deploy] = true

  # nodejs
  default[:deploy][application][:nodejs][:restart_command] = "monit restart node_web_app_#{application}"
  default[:deploy][application][:nodejs][:stop_command] = "monit stop node_web_app_#{application}"
end

default[:opsworks][:skip_uninstall_of_other_rails_stack] = false
