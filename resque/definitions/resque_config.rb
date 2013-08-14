define :resque_config,
  :path => nil,
  :owner => nil,
  :group => nil,
  :bundler => false,
  :envs => [],
  :memory_limit => "100.megabytes",
  :check_every => "1.minute",
  :restart_after => "[3,5]" do
    path = "#{params[:path]}"
    pids_path = "#{path}/shared/pids"

    directory pids_path do
      owner params[:owner]
      group params[:group]
      mode "0755"
      recursive true
    end

    template "#{path}/shared/resque.pill" do
      owner params[:owner]
      group params[:group]
      mode "0644"
      source "resque.pill.erb"
      cookbook "resque"
      variables({
        :app        => params[:name],
        :path       => path,
        :pids_path  => pids_path,
        :owner      => params[:owner],
        :group      => params[:group],
        :bundler    => params[:bundler],
        :envs       => params[:envs],
        :memory_limit   => params[:memory_limit],
        :check_every    => params[:check_every],
        :restart_after  => params[:restart_after]
      })
      backup false
    end

    #execute "Ensuring bluepill is monitoring resque" do
      #command %Q{
        #bundle exec bluepill load #{path}/shared/resque.pill
      #}
    #end
end
