require 'tmpdir'

module Scalarium
  module SCM
    module Archive
      def prepare_archive_checkouts(archive_url)
        tmpdir = Dir.mktmpdir('scalarium')
        directory tmpdir do
          mode 0755
        end

        remote_file "#{tmpdir}/archive" do
          source archive_url
        end

        execute 'extract files' do
          command "/root/scalarium-agent/bin/extract #{tmpdir}/archive"
        end

        execute 'create git repository' do
          creates "#{tmpdir}/archive.d/.git"
          cwd "#{tmpdir}/archive.d"
          command "git init; git add .; git commit -m 'Create temporary repository from downloaded contents.'"
        end

        "#{tmpdir}/archive.d"
      end
    end
  end
end

class Chef::Recipe
  include Scalarium::SCM::Archive
end