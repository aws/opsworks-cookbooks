define :scalarium_deploy_dir do

  # create shared/ directory structure
  %w(log config system pids scripts sockets).each do |dir_name|
    directory "#{params[:path]}/shared/#{dir_name}" do
      group params[:group]
      owner params[:user]
      mode "0770"
      action :create
      recursive true
    end
  end

end
