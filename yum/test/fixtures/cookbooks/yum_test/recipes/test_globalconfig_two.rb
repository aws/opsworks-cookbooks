# Full blown parameterization. Exercercises the
# recipe->resource->provider->template chain
yum_globalconfig '/tmp/yum-full.conf' do
  alwaysprompt true
  assumeyes true
  bandwidth '40'
  bugtracker_url 'http://somewhere.eltz.biz'
  clean_requirements_on_remove true
  cachedir '/path/to/somewhere/good'
  color 'always'
  color_list_available_downgrade 'fg:green'
  color_list_available_install 'fg:green'
  color_list_available_reinstall 'fg:green'
  color_list_available_upgrade 'fg:green'
  color_list_installed_extra 'fg:green'
  color_list_installed_newer 'fg:green'
  color_list_installed_older 'fg:green'
  color_list_installed_reinstall 'fg:green'
  color_search_match 'bold'
  color_update_installed 'fg:blue'
  color_update_local 'fg:blue'
  color_update_remote 'fg:blue'
  commands '--installroot=root=/over/there'
  debuglevel '5'
  diskspacecheck true
  distroverpkg 'fedora-release'
  enable_group_conditionals true
  errorlevel '5'
  exactarch true
  exclude 'kernel emacs-nox'
  gpgcheck true
  group_package_types 'default mandatory'
  groupremove_leaf_only false
  history_list_view 'commands'
  history_record true
  history_record_packages 'rpm'
  http_caching 'all'
  installonly_limit '3'
  installonlypkgs 'kernel, emacs-nox'
  installroot '/over/there'
  keepalive true
  keepcache true
  kernelpkgnames 'dowhatnow'
  localpkg_gpgcheck true
  logfile '/your/logs/here'
  max_retries '10'
  mdpolicy 'instant'
  metadata_expire '21600'
  mirrorlist_expire '21600'
  multilib_policy 'best'
  obsoletes false
  overwrite_groups true
  password 'ohai'
  path '/tmp/yum-full.conf'
  persistdir '/somewhere/good'
  pluginconfpath '/etc/yum/pluginconf.d'
  pluginpath '/path/to /some/plugins'
  plugins true
  protected_multilib true
  protected_packages 'yum glob:/etc/yum/protected.d/*.conf'
  proxy 'https://datproxy.biz'
  proxy_password 'evewashere'
  proxy_username 'alice'
  recent '7'
  repo_gpgcheck true
  reset_nice true
  rpmverbosity 'warn'
  showdupesfromrepos true
  skip_broken false
  ssl_check_cert_permissions true
  sslcacert '/path/to/cacert'
  sslclientcert '/path/to/clientcert'
  sslclientkey '/path/to/clientkey'
  sslverify true
  syslog_device '/dev/log'
  syslog_facility 'LOG_USER'
  syslog_ident 'chuck norris'
  throttle '100000M'
  timeout '30'
  tolerant false
  tsflags 'noscripts'
  username 'baub'
  action :create
end
