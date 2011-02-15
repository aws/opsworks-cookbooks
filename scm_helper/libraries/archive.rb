module Scalarium
  module SCM
    module Archive
      def prepare_archive_checkouts(deploy)
        remote_file "#{deploy[:deploy_to]}/shared/archive" do
          source deploy[:scm][:repository]
        end

        directory "#{deploy[:deploy_to]}/shared/archive.d" do
          action :delete
          recursive true
        end

        execute 'extract files' do
          command "/root/scalarium-agent/bin/extract #{deploy[:deploy_to]}/shared/archive"
        end

        execute 'create git repository' do
          cwd "#{deploy[:deploy_to]}/shared/archive.d"
          command "git init; git add .; git commit -m 'Create temporary repository from downloaded contents.'"
        end

        deploy[:scm] = {
          :scm_type => 'git',
          :repository => "#{deploy[:deploy_to]}/shared/archive.d"
        }
      end
    end
  end
end

class Chef::Recipe
  include Scalarium::SCM::Archive
end