include_attribute "elasticsearch::default"
include_attribute "elasticsearch::nginx"

# Try to load data bag item 'elasticsearch/aws' ------------------
#
users = Chef::DataBagItem.load('elasticsearch', 'users')[node.chef_environment]['users'] rescue []
# ----------------------------------------------------------------

# === NGINX ===
# Allowed users are set based on data bag values, when it exists.
#
# It's possible to define the credentials directly in your node configuration, if your wish.
#
default.elasticsearch[:nginx][:server_name]    = "elasticsearch"
default.elasticsearch[:nginx][:port]           = "8080"
default.elasticsearch[:nginx][:dir]            = ( node.nginx[:dir]     rescue '/etc/nginx'     )
default.elasticsearch[:nginx][:user]           = ( node.nginx[:user]    rescue 'nginx'          )
default.elasticsearch[:nginx][:log_dir]        = ( node.nginx[:log_dir] rescue '/var/log/nginx' )
default.elasticsearch[:nginx][:users]          = users
default.elasticsearch[:nginx][:passwords_file] = "#{node.elasticsearch[:path][:conf]}/passwords"

# Deny or allow authenticated access to cluster API.
#
# Set this to `true` if you want to use a tool like BigDesk
#
default.elasticsearch[:nginx][:allow_cluster_api] = false

# Allow responding to unauthorized requests for `/status`,
# returning `curl -I localhost:9200`
#
default.elasticsearch[:nginx][:allow_status] = false

# Other Nginx proxy settings
#
default.elasticsearch[:nginx][:client_max_body_size] = "50M"
default.elasticsearch[:nginx][:location]             = "/"
default.elasticsearch[:nginx][:ssl][:cert_file]      = nil
default.elasticsearch[:nginx][:ssl][:key_file]       = nil
