node[:deploy].each do |application, deploy|

  # execute 'limpa o crontab' do
  #   command "crontab -u deploy -r"
  #   Chef::Log.info "todas as entradas do crontab foram removidas"
  # end

  execute 'inicializa o tickets consumer' do
    user "deploy"
    command "cd #{deploy[:current_path]}/tickets_consumer && bundle install --path vendor/bundle && bundle exec whenever -w --set \'environment=#{deploy[:rails_env]}\'"
    Chef::Log.info "tickets_consumer instalado e agendado"
    Chef::Log.info "`crontab -l`"
  end

end
