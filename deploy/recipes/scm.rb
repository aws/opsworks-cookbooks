node[:deploy].each do |application, deploy|
  
  ensure_scm_package_installed(deploy[:scm][:scm_type])
  
  
  prepare_git_checkouts(:user => deploy[:user], 
                        :group => deploy[:group], 
                        :home => deploy[:home], 
                        :ssh_key => deploy[:scm][:ssh_key]) if deploy[:scm][:scm_type].to_s == 'git'
                        
  prepare_svn_checkouts(:user => deploy[:user], 
                        :group => deploy[:group], 
                        :home => deploy[:home]) if deploy[:scm][:scm_type].to_s == 'svn'
end
