require 'tmpdir'

module Scalarium
  module SCM
    module S3
      def prepare_s3_checkouts(scm_options)
        template "/root/.s3curl" do
          cookbook "scm_helper"
          source "s3curl.erb"
          mode '0600'
          variables(:access_key => scm_options[:user], :secret_key => scm_options[:password])
        end

        tmpdir = Dir.mktmpdir('scalarium')
        directory tmpdir do
          mode 0755
        end

        execute "Download application from S3: #{scm_options[:repository]}" do
          command "#{node[:scalarium_agent_root]}/bin/s3curl.pl --id scalarium -- -o #{tmpdir}/archive #{scm_options[:repository]}"
        end

        execute 'extract files' do
          command "#{node[:scalarium_agent_root]}/bin/extract #{tmpdir}/archive"
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
  include Scalarium::SCM::S3
end