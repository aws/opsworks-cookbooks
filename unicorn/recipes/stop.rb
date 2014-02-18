# stop Unicorn service per app
node[:deploy].each do |application, deploy|
  if deploy[:application_server_type] != 'rack' && deploy[:application_type] != 'rails' && deploy[:application_type] != 'sinatra'
    Chef::Log.debug("Skipping unicorn::stop application #{application} as it is not specified to have a rack server, nor a Rails, nor Sinatra app")
    next
  end

  execute "stop unicorn" do
    command "#{deploy[:deploy_to]}/shared/scripts/unicorn stop"
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/scripts/unicorn")
    end
  end
end
