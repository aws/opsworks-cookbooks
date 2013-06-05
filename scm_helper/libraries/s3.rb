require 'tmpdir'

module OpsWorks
  module SCM
    module S3
      def prepare_s3_checkouts(scm_options)
        template "/root/.s3curl" do
          cookbook "scm_helper"
          source "s3curl.erb"
          mode '0600'
          variables(:access_key => scm_options[:user], :secret_key => scm_options[:password])
        end

        tmpdir = Dir.mktmpdir('opsworks')
        directory tmpdir do
          mode 0755
        end

        execute "Download application from S3: #{scm_options[:repository]}" do
          command "#{node[:opsworks_agent][:current_dir]}/bin/s3curl.pl --id opsworks -- -o #{tmpdir}/archive #{scm_options[:repository]}"
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
  include OpsWorks::SCM::S3
end
