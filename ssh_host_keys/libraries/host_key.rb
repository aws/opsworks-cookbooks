module OpsWorks
  module HostKey
    def write_host_key(params)
      template params[:path] do
        backup false
        cookbook 'ssh_host_keys'
        source 'ssh_key.erb'
        owner 'root'
        group 'root'
        mode params[:mode]
        variables :ssh_key => params[:content]

        not_if do
          params[:content].blank?
        end
      end
    end
  end
end

class Chef::Recipe
  include OpsWorks::HostKey
end
