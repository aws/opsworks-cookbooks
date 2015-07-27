file "/etc/apt/sources.list.d/docker.list" do
  content "deb #{node["opsworks_ecs"]["ubuntu_docker_repository"]["url"]} #{node["lsb"]["id"].downcase}-#{node["lsb"]["codename"]} #{node["opsworks_ecs"]["ubuntu_docker_repository"]["component"]}"
end

execute "Import docker repository key" do
  command "apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys #{node["opsworks_ecs"]["ubuntu_docker_repository"]["fingerprint"]}"
  retries 5

  not_if do
    OpsWorks::ShellOut.shellout("apt-key adv --list-public-keys #{node["opsworks_ecs"]["ubuntu_docker_repository"]["fingerprint"]}") rescue false
  end
end

execute "apt-get update"

package "docker-engine" do
  options "--no-install-recommends"
end
