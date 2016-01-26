normal[:puma][:recipe] = "puma::default"
normal[:puma][:needs_reload] = true
normal[:puma][:service] = 'puma'
normal[:puma][:restart_command] = '../../shared/scripts/puma clean-restart'
