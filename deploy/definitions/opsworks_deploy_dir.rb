define :opsworks_deploy_dir do

  # create shared/ directory structure
  ['log','config','system','pids','scripts'].each do |dir_name|
    directory "#{params[:path]}/shared/#{dir_name}" do
      group params[:group]
      owner params[:user]
      mode 0770
      action :create
      recursive true
    end
  end
  
  directory "#{params[:path]}/shared/sockets" do
    group params[:group]
    owner params[:user]
    mode 0777
    action :create
    recursive true
  end

end
