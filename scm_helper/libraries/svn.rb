module Scalarium
  module SCM
    module SVN
      
      def prepare_svn_checkouts(options = {})
        raise ArgumentError, "need :user, :group, and :home" unless options.has_key?(:user) && options.has_key?(:group) && options.has_key?(:home)
        
        directory "#{options[:home]}/.subversion" do
          owner options[:user]
          group options[:group]
          mode "0700"
          action :create
          recursive true  
        end

        template "#{options[:home]}/.subversion/servers" do
          owner options[:user]
          group options[:group]
          mode '0600'
          cookbook "scm_helper"
          source "subversion_servers.erb"
        end
        
      end
      
    end
  end
end

class Chef::Recipe
  include Scalarium::SCM::SVN
end