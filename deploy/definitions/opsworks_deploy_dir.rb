define :opsworks_deploy_dir do

  # before creating a deploy directory ensure
  # bind mounts have been made due to a race condition
  # with the automounter

  if node[:opsworks_initial_setup].attribute?(:bind_mounts)
    node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
      bash "Check for bind mounts before creating the deploy directory" do
        code <<-EOH
          retries=3
          until grep -q #{dir} /proc/mounts; do
            if [[ $(( retries-- )) -lt 1 ]]; then
              echo "Bind mount check failed for #{dir}"
              exit 1
            fi
            sleep 2
          done
        EOH
        ignore_failure true
        only_if { infrastructure_class?("ec2") }
      end
    end
  end


  directory "#{params[:path]}/shared" do
    group params[:group]
    owner params[:user]
    mode 0770
    action :create
    recursive true
  end

  # create shared/ directory structure
  ['log','config','system','pids','scripts','sockets'].each do |dir_name|
    directory "#{params[:path]}/shared/#{dir_name}" do
      group params[:group]
      owner params[:user]
      mode 0770
      action :create
      recursive true
    end
  end

  bash "Enable selinux httpd_var_run_t target for unicorn socket" do
    dir_path_socket = "#{params[:path]}/shared/sockets"
    context = "httpd_var_run_t"

    user "root"
    code <<-EOH
    semanage fcontext --add --type #{context} "#{dir_path_socket}(/.*)?" && restorecon -rv "#{dir_path_socket}"
    EOH
    not_if { OpsWorks::ShellOut.shellout("/usr/sbin/semanage fcontext -l") =~ /^#{Regexp.escape("#{dir_path_socket}(/.*)?")}\s.*\ssystem_u:object_r:#{context}:s0/ }
    only_if { platform_family?("rhel") && ::File.exist?("/usr/sbin/getenforce") && OpsWorks::ShellOut.shellout("/usr/sbin/getenforce").strip == "Enforcing" }
  end
end
