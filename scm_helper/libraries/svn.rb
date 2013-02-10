module OpsWorks
  module SCM
    module SVN
      
      def prepare_svn_checkouts(options = {})
        raise ArgumentError, "need :user, :group, and :home" unless options.has_key?(:user) && options.has_key?(:group) && options.has_key?(:home)
        
        deploy = options[:deploy]
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

        subversion "Init Subversion configuration for #{options[:application]}" do
          repository deploy[:scm][:repository]
          user deploy[:user]
          group deploy[:group]
          svn_username deploy[:scm][:user]
          svn_password deploy[:scm][:password]
          provider Chef::Provider::SubversionInit
          action :sync
        end
      end
    end
  end
end

class Chef::Provider::SubversionInit < Chef::Provider::Subversion
  def scm(*args)
    ['yes p | svn', *args].compact.join(" ")
  end

  def action_sync
    command = scm(:info, @new_resource.repository, @new_resource.svn_info_args, authentication)
    status, svn_info, error_message = output_of_command(command, run_options)
  end
end

class Chef::Recipe
  include OpsWorks::SCM::SVN
end
