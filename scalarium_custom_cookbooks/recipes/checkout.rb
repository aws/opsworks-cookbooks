ensure_scm_package_installed(node[:scalarium_custom_cookbooks][:scm][:type])

prepare_git_checkouts(:user => node[:scalarium_custom_cookbooks][:user], 
                      :group => node[:scalarium_custom_cookbooks][:group], 
                      :home => node[:scalarium_custom_cookbooks][:home], 
                      :ssh_key => node[:scalarium_custom_cookbooks][:scm][:ssh_key]) if node[:scalarium_custom_cookbooks][:scm][:type].to_s == 'git'
                      
prepare_svn_checkouts(:user => node[:scalarium_custom_cookbooks][:user], 
                      :group => node[:scalarium_custom_cookbooks][:group], 
                      :home => node[:scalarium_custom_cookbooks][:home]) if node[:scalarium_custom_cookbooks][:scm][:type].to_s == 'svn'

if node[:scalarium_custom_cookbooks][:scm][:type].to_s == 'archive'
  repository = prepare_archive_checkouts(node[:scalarium_custom_cookbooks][:scm])
  node[:scalarium_custom_cookbooks][:scm] = {
    :type => 'git',
    :repository => repository
  }
end

scm "Download Custom Cookbooks" do
  user node[:scalarium_custom_cookbooks][:user]
  group node[:scalarium_custom_cookbooks][:group]
  
  case node[:scalarium_custom_cookbooks][:scm][:type]
  when 'git'
    provider Chef::Provider::Git
    enable_submodules node[:scalarium_custom_cookbooks][:enable_submodules]
    depth nil
  when 'svn'
    provider Chef::Provider::Subversion
    svn_username node[:scalarium_custom_cookbooks][:scm][:user]
    svn_password node[:scalarium_custom_cookbooks][:scm][:password]
  else
    raise "unsupported SCM type #{node[:scalarium_custom_cookbooks][:scm][:type].inspect}"
  end
  
  action :checkout
  destination node[:scalarium_custom_cookbooks][:destination]
  repository node[:scalarium_custom_cookbooks][:scm][:repository]
  revision node[:scalarium_custom_cookbooks][:scm][:revision]
  user node[:scalarium_custom_cookbooks][:user]
  
  not_if do
    node[:scalarium_custom_cookbooks][:scm][:repository].blank? || ::File.directory?(node[:scalarium_custom_cookbooks][:destination])
  end
end
