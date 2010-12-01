default[:deploy] = {}
deploy.each do |application, deploy|
  default[:deploy][application] = {}
  default[:deploy][application][:deploy_to] = "/srv/www/#{application}"
  default[:deploy][application][:scm] = {}
  default[:deploy][application][:scm][:scm_type] = "git"
  default[:deploy][application][:scm][:revision] = "HEAD"
  default[:deploy][application][:release] = Time.now.utc.strftime("%Y%m%d%H%M%S")
  default[:deploy][application][:release_path] = "#{deploy[:deploy_to]}/releases/#{deploy[:release]}"
  default[:deploy][application][:current_path] = "#{deploy[:deploy_to]}/current"
  default[:deploy][application][:document_root] = ""
  if deploy[:document_root]
    default[:deploy][application][:absolute_document_root] = "#{default[:deploy][application][:current_path]}/#{deploy[:document_root]}/"
  else
    default[:deploy][application][:absolute_document_root] = "#{default[:deploy][application][:current_path]}/"
  end
  
  if File.exists?("/usr/local/bin/rake")
    # Ruby Enterprise Edition rake is installed
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
  home = self[:passwd] && 
         self[:passwd][self[:deploy][application][:user]] &&
         self[:passwd][self[:deploy][application][:user]][:dir] || "/home/#{self[:deploy][application][:user]}"

  default[:deploy][application][:home] = home
  default[:deploy][application][:stack] = {}
  default[:deploy][application][:stack][:recipe] = "passenger_apache2::rails"
  default[:deploy][application][:stack][:needs_reload] = true
  default[:deploy][application][:stack][:service] = 'apache2'

  default[:deploy][application][:sleep_before_restart] = 0
  default[:deploy][application][:restart_command] = "touch tmp/restart.txt"
  default[:deploy][application][:enable_submodules] = true
  default[:deploy][application][:shallow_clone] = true
  default[:deploy][application][:symlink_before_migrate] = {"config/database.yml" => "config/database.yml"}
  
  default[:deploy][application][:environment] = {"RAILS_ENV" => deploy[:rails_env],
                                                 "RUBYOPT" => "",
                                                 "RACK_ENV" => deploy[:rails_env],
                                                 "HOME" => deploy[:home]}
  default[:deploy][application][:ssl_support] = false
end

default[:logrotate] = {}
default[:logrotate][:rotate] = 30
default[:logrotate][:dateformat] = false # set to '-%Y%m%d' to have date formatted logs
