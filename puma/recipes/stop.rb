# stop Unicorn service per app
node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping puma::rails application #{application} as it is not an Rails app")
    next
  end

  execute "stop puma" do
    command "#{deploy[:deploy_to]}/shared/scripts/puma stop"
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/scripts/puma")
    end
  end
end
