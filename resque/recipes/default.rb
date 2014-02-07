#
# Cookbook Name:: resque
# Recipe:: default
#
#
# We're not setting up Resque this way
# because our projects use different rubies and specify their gems via Bundler
#
# if ['solo', 'util'].include?(node[:instance_role])
#   %w[bluepill resque redis redis-namespace yajl-ruby].each do |install_gem|
#     if node.run_state[:seen_recipes].has_key?("ruby_enterprise")
#       ree_gem install_gem
#     else
#       gem_package install_gem
#     end
#   end
# end
