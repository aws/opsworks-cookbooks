include_attribute 'rails::rails'

# Usually this should be a dynamic value but we are using threads in order to scale properly
default[:puma][:workers] = 4
default[:puma][:preload_app] = true
default[:puma][:version] = '2.8.0'
default[:puma][:threads_min] = node[:rails][:max_pool_size] ? node[:rails][:max_pool_size]/8 : 0
default[:puma][:threads_max] = node[:rails][:max_pool_size] ? node[:rails][:max_pool_size]/4 : 4
