default[:deploy] = {}
node[:deploy].each do |application, deploy|
  default[:deploy][application][:deploy_to] = "/srv/www/#{application}"
  default[:deploy][application][:release] = Time.now.utc.strftime("%Y%m%d%H%M%S")
  default[:deploy][application][:release_path] = "#{node[:deploy][application][:deploy_to]}/releases/#{node[:deploy][application][:release]}"
  default[:deploy][application][:current_path] = "#{node[:deploy][application][:deploy_to]}/current"
  default[:deploy][application][:document_root] = ""
  if deploy[:document_root]
    default[:deploy][application][:absolute_document_root] = "#{default[:deploy][application][:current_path]}/#{deploy[:document_root]}/"
  else
    default[:deploy][application][:absolute_document_root] = "#{default[:deploy][application][:current_path]}/"
  end
  
  if File.exists?("/usr/local/bin/rake")
    # local Ruby rake is installed
    default[:deploy][application][:rake] = "/usr/local/bin/rake"
  else
    # use default Rake/ruby
    default[:deploy][application][:rake] = "rake"
  end
  default[:deploy][application][:migrate] = false
  default[:deploy][application][:migrate_command] = "#{default[:deploy][application][:rake]} db:migrate"
  default[:deploy][application][:rails_env] = 'production'
  default[:deploy][application][:action] = 'deploy'
  default[:deploy][application][:user] = 'deploy'
  default[:deploy][application][:group] = 'www-data'
  default[:deploy][application][:shell] = '/bin/zsh'
  home = self[:passwd] && 
         self[:passwd][self[:deploy][application][:user]] &&
         self[:passwd][self[:deploy][application][:user]][:dir] || "/home/#{self[:deploy][application][:user]}"

  default[:deploy][application][:home] = home
  default[:deploy][application][:stack][:recipe] = "passenger_apache2::rails"
  default[:deploy][application][:stack][:needs_reload] = true
  default[:deploy][application][:stack][:service] = 'apache2'

  default[:deploy][application][:sleep_before_restart] = 0
  default[:deploy][application][:restart_command] = "touch tmp/restart.txt"
  default[:deploy][application][:enable_submodules] = true
  default[:deploy][application][:shallow_clone] = true
  default[:deploy][application][:symlink_before_migrate] = {}
  
  default[:deploy][application][:environment] = {"RAILS_ENV" => deploy[:rails_env],
                                                 "RUBYOPT" => "",
                                                 "RACK_ENV" => deploy[:rails_env],
                                                 "HOME" => home}
  default[:deploy][application][:ssl_support] = false
  default[:deploy][application][:auto_npm_install_on_deploy] = true

  # nodejs
  default[:deploy][application][:nodejs][:restart_command] = "monit restart node_web_app_#{application}"
end

default[:logrotate][:rotate] = 30
default[:logrotate][:dateformat] = false # set to '-%Y%m%d' to have date formatted logs
