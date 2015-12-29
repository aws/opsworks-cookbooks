require 'tmpdir'

module OpsWorks
  module SCM
    module S3
      def self.parse_uri(uri)
        uri = URI.parse(uri)
        uri_path_components = uri.path.split("/").reject{|p| p.empty?}
        virtual_host_match = uri.host.match(/\A(.+)\.s3(?:-(?:ap|eu|sa|us)-.+-\d)?\.amazonaws\.com/i)
        if virtual_host_match
          # virtual-hosted-style: http://bucket.s3.amazonaws.com or http://bucket.s3-aws-region.amazonaws.com
          bucket = virtual_host_match[1]
          remote_path = uri_path_components.join("/")
        else
          # path-style: http://s3.amazonaws.com/bucket or http://s3-aws-region.amazonaws.com/bucket
          bucket = uri_path_components[0]
          remote_path = uri_path_components[1..-1].join("/")
        end

        [bucket, remote_path]
      end

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

        s3_bucket, s3_key = OpsWorks::SCM::S3.parse_uri(scm_options[:repository])

        s3_file "#{tmpdir}/archive" do
          bucket s3_bucket
          remote_path s3_key
          aws_access_key_id scm_options[:user]
          aws_secret_access_key scm_options[:password]
          owner "root"
          group "root"
          mode "0600"
          # per default it's host-style addressing
          # but older versions of rest-client doesn't support host-style addressing with `_` in bucket name
          s3_url "https://s3.amazonaws.com/#{s3_bucket}" if s3_bucket.include?("_")
          action :create
        end

        execute 'extract files' do
          command "#{node[:opsworks_agent][:current_dir]}/bin/extract #{tmpdir}/archive"
        end

        execute 'create git repository' do
          cwd "#{tmpdir}/archive.d"
          command "find . -type d -name .git -exec rm -rf {} \\;; find . -type f -name .gitignore -exec rm -f {} \\;; git init; git add .; git config user.name 'AWS OpsWorks'; git config user.email 'root@localhost'; git commit -m 'Create temporary repository from downloaded contents.'"
        end

        "#{tmpdir}/archive.d"
      end
    end
  end
end

class Chef::Recipe
  include OpsWorks::SCM::S3
end
