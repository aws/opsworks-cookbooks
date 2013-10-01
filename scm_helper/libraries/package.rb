module OpsWorks
  module SCM
    module Package
      
      def ensure_scm_package_installed(scm_type)
        if scm_type == "git"
          case node[:platform]
          when "debian", "ubuntu"
            package "git-core"
          else 
            package "git"
          end
        elsif scm_type == "svn"
          package "subversion"
        elsif scm_type == 'archive' || scm_type == 's3'
          case node[:platform]
          when 'debian', 'ubuntu'
            package 'git-core'
            package 'libdigest-hmac-perl'
          else
            package 'git'
            package 'perl-Digest-HMAC'
          end
          package 'unzip'
        elsif scm_type == 'other'
          Chef::Log.info "scm_type 'other', nothing to install"
        else
          raise "unsupported SCM type #{scm_type}"
        end
      end
      
    end
  end
end

class Chef::Recipe
  include OpsWorks::SCM::Package
end
