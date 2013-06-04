ensure_scm_package_installed(node[:opsworks_custom_cookbooks][:scm][:type]) unless node[:opsworks_custom_cookbooks][:scm][:type].nil?

prepare_git_checkouts(:user => node[:opsworks_custom_cookbooks][:user],
                      :group => node[:opsworks_custom_cookbooks][:group],
                      :home => node[:opsworks_custom_cookbooks][:home],
                      :ssh_key => node[:opsworks_custom_cookbooks][:scm][:ssh_key]) if node[:opsworks_custom_cookbooks][:scm][:type].to_s == 'git'

prepare_svn_checkouts(:user => node[:opsworks_custom_cookbooks][:user],
                      :group => node[:opsworks_custom_cookbooks][:group],
                      :home => node[:opsworks_custom_cookbooks][:home],
                      :deploy => node[:opsworks_custom_cookbooks]) if node[:opsworks_custom_cookbooks][:scm][:type].to_s == 'svn'

if node[:opsworks_custom_cookbooks][:scm][:type].to_s == 'archive'
  repository = prepare_archive_checkouts(node[:opsworks_custom_cookbooks][:scm])
  node.set[:opsworks_custom_cookbooks][:scm] = {
    :type => 'git',
    :repository => repository
  }
elsif node[:opsworks_custom_cookbooks][:scm][:type].to_s == 's3'
  repository = prepare_s3_checkouts(node[:opsworks_custom_cookbooks][:scm])
  node.set[:opsworks_custom_cookbooks][:scm] = {
   :scm_type => 'git',
   :repository => repository
  }
end

scm "Download Custom Cookbooks" do
  user node[:opsworks_custom_cookbooks][:user]
  group node[:opsworks_custom_cookbooks][:group]

  case node[:opsworks_custom_cookbooks][:scm][:type]
  when 'git'
    provider Chef::Provider::Git
    enable_submodules node[:opsworks_custom_cookbooks][:enable_submodules]
    depth nil
  when 'svn'
    provider Chef::Provider::Subversion
    svn_username node[:opsworks_custom_cookbooks][:scm][:user]
    svn_password node[:opsworks_custom_cookbooks][:scm][:password]
  else
    raise "unsupported SCM type #{node[:opsworks_custom_cookbooks][:scm][:type].inspect}"
  end

  action :checkout
  destination node[:opsworks_custom_cookbooks][:destination]
  repository node[:opsworks_custom_cookbooks][:scm][:repository]
  revision node[:opsworks_custom_cookbooks][:scm][:revision]
  user node[:opsworks_custom_cookbooks][:user]

  not_if do
    node[:opsworks_custom_cookbooks][:scm][:repository].blank? || ::File.directory?(node[:opsworks_custom_cookbooks][:destination])
  end
end

execute "ensure correct permissions of custom cookbooks" do
  command "chmod -R go-rwx #{node[:opsworks_custom_cookbooks][:destination]}"
  only_if do
    ::File.exists?(node[:opsworks_custom_cookbooks][:destination])
  end
end
