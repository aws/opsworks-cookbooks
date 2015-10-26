service "ecs" do
  action :stop

  provider Chef::Provider::Service::Upstart

  only_if { platform?("amazon") }
end

execute "Stop ECS agent" do
  command "docker stop $(docker ps -a | grep amazon-ecs-agent | awk '{print $1}')"

  only_if do
    ::File.exist?("/usr/bin/docker") && OpsWorks::ShellOut.shellout("docker ps -a").include?("amazon-ecs-agent")
  end
end

execute "Remove ECS agent" do
  command "docker rm $(docker ps -a | grep amazon-ecs-agent | awk '{print $1}')"

  only_if do
    ::File.exist?("/usr/bin/docker") && OpsWorks::ShellOut.shellout("docker ps -a").include?("amazon-ecs-agent")
  end
end
