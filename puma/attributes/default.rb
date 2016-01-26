default[:puma][:recipe] = "puma::default"
default[:puma][:needs_reload] = true
default[:puma][:service] = 'puma'
default[:puma][:restart_command] = '../../shared/scripts/puma clean-restart'
