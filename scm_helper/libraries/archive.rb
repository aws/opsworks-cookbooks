require 'tmpdir'

module OpsWorks
  module SCM
    module Archive
      def prepare_archive_checkouts(scm_options)
        unless scm_options[:user].blank? || scm_options[:password].blank?
          archive_url = URI.parse(scm_options[:repository])
          archive_url.user = scm_options[:user]
          archive_url.password = scm_options[:password]
          archive_url = archive_url.to_s
        else
          archive_url = scm_options[:repository]
        end

        tmpdir = Dir.mktmpdir('opsworks')
        directory tmpdir do
          mode 0755
        end

        remote_file "#{tmpdir}/archive" do
          source archive_url
        end

        execute 'extract files' do
          command "#{node[:opsworks_agent][:current_dir]}/bin/extract #{tmpdir}/archive"
        end

        execute 'create git repository' do
          cwd "#{tmpdir}/archive.d"
          command "rm -rf .git; git init; git add .; git commit -m 'Create temporary repository from downloaded contents.'"
        end

        "#{tmpdir}/archive.d"
      end
    end
  end
end

class Chef::Recipe
  include OpsWorks::SCM::Archive
end
