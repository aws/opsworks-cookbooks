directory node[:percona][:tmp_dir] do
  recursive true
  action :create
end

execute "Download Percona XtraDB Server" do
  cwd node[:percona][:tmp_dir]
  command "wget #{node[:percona][:url_base]}/#{node[:percona][:version]}/#{node[:lsb][:release]}_#{node[:scalarium][:instance][:architecture]}.tar.bzip2"
  not_if do
    File.exists?("#{node[:percona][:tmp_dir]}/#{node[:scalarium][:instance][:architecture]}.tar.bzip2")
  end
end

execute "Extract Percona XtraDB Server" do
  cwd node[:percona][:tmp_dir]
  command "tar -xvjf *.tar.bzip2 && rm -f *.tar.bzip2"
  not_if do
    File.directory?("#{node[:percona][:tmp_dir]}/#{node[:scalarium][:instance][:architecture]}")
  end
end