define :puma_deploy_dir do

  directory "#{params[:path]}/shared" do
    group 'nginx'
    owner params[:user]
    mode 0770
    action :create
    recursive true
  end

  # create shared/ directory structure

  ['log','config','system','pids','scripts','sockets'].each do |dir_name|
    directory "#{params[:path]}/shared/#{dir_name}" do
      group 'nginx'
      owner params[:user]
      mode 0770
      action :create
      recursive true
    end
  end

end
