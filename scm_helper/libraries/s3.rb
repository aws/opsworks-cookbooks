require 'tmpdir'

module OpsWorks
  module SCM
    module S3
      def self.parse_uri(uri)
        uri = URI.parse(uri)
        uri_path_components = uri.path.split("/").reject{|p| p.empty?}
        virtual_host_match = uri.host.match(/\A(.+)\.s3(?:[-.](?:ap|eu|sa|us)-(?:.+-)\d|-external-1)?\.amazonaws\.com/i)
        base_uri = uri.dup

        if virtual_host_match
          # virtual-hosted-style: http://bucket.s3.amazonaws.com or http://bucket.s3-aws-region.amazonaws.com
          bucket = virtual_host_match[1]
          base_uri.path = "/"
        else
          # path-style: http://s3.amazonaws.com/bucket or http://s3-aws-region.amazonaws.com/bucket
          bucket = uri_path_components[0]
          base_uri.path = "/#{uri_path_components.shift}"
        end

        remote_path = uri_path_components.join("/") # remote_path don't allow a "/" at the beginning

        [bucket, remote_path, base_uri.to_s.chomp("/")] # base_url don't allow a "/" at the end
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

        s3_bucket, s3_key, base_url = OpsWorks::SCM::S3.parse_uri(scm_options[:repository])

        s3_file "#{tmpdir}/archive" do
          bucket s3_bucket
          remote_path s3_key
          aws_access_key_id scm_options[:user]
          aws_secret_access_key scm_options[:password]
          owner "root"
          group "root"
          mode "0600"
          s3_url base_url
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
