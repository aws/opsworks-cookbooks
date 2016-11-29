node[:deploy].each do |application, deploy|
  
  execute 'composer_install' do
    command 'composer install'
    cwd deploy[:current_path]
    only_if { ::File.exist?("#{deploy[:current_path]}/composer.json") }
  end
  
end