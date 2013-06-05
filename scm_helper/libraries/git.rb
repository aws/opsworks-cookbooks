module OpsWorks
  module SCM
    module Git
      
      def prepare_git_checkouts(options = {})
        raise ArgumentError, "need :user, :group, and :home" unless options.has_key?(:user) && options.has_key?(:group) && options.has_key?(:home)
        
        directory "#{options[:home]}/.ssh" do
          owner options[:user]
          group options[:group]
          mode "0700"
          action :create
          recursive true  
        end
        
        file "#{options[:home]}/.ssh/config" do
          owner options[:user]
          group options[:group]
          action :touch
          mode '0600'
        end
        
        execute "echo 'StrictHostKeyChecking no' > #{options[:home]}/.ssh/config" do
          not_if "grep '^StrictHostKeyChecking no$' #{options[:home]}/.ssh/config"
        end
        
        template "#{options[:home]}/.ssh/id_dsa" do
          action :create
          mode '0600'
          owner options[:user]
          group options[:group]
          cookbook "scm_helper"
          source 'ssh_key.erb'
          variables :ssh_key => options[:ssh_key]
          not_if do
            options[:ssh_key].blank?
          end
        end
      
      end
      
    end
  end
end

class Chef::Recipe
  include OpsWorks::SCM::Git
end
