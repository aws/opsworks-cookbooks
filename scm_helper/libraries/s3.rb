require 'tmpdir'

module OpsWorks
  module SCM
    module S3
      def self.parse_uri(uri)
        #                base_uri                |         remote_path
        #----------------------------------------+------------------------------
        # scheme, userinfo, host, port, registry | path, opaque, query, fragment

        components = URI.split(uri)
        base_uri = URI::HTTP.new(*(components.take(5) + [nil] * 4))
        remote_path = URI::HTTP.new(*([nil] * 5 + components.drop(5)))

        virtual_host_match = base_uri.host.match(/\A(.+)\.s3(?:-website|.dualstack)?([-.](ap|ca|cn|eu|sa|us)-(.+-)\d|-external-1)?\.amazonaws\.com/i)

        if virtual_host_match
          # virtual-hosted-style: http://bucket.s3.amazonaws.com or http://bucket.s3-aws-region.amazonaws.com
          bucket = virtual_host_match[1]
          if virtual_host_match[2]
            region = virtual_host_match[2][1..-1]
            region = "us-east-1" if region == "external-1"
          else
            region = "us-east-1"
          end
        else
          # path-style: http://s3.amazonaws.com/bucket or http://s3-aws-region.amazonaws.com/bucket
          uri_path_components = remote_path.path.split("/").reject(&:empty?)
          bucket = uri_path_components.shift # cut first element
          base_uri.path = "/#{bucket}" # append bucket to base_uri
          remote_path.path = uri_path_components.join("/") # delete bucket from remote_path

          if base_uri.host == "s3.amazonaws.com"
            region = "us-east-1"
          elsif base_uri.host == "s3-external-1.amazonaws.com"
            region = "us-east-1"
          elsif base_uri.host == "s3-website.amazonaws.com"
            region = "us-east-1"
          elsif base_uri.host.start_with? "s3.dualstack"
            region = base_uri.host.split('.')[2]
          else
            region = base_uri.host.sub(/^s3(?:-website)?[-.]/i, '').split('.')[0]
          end
        end

        # remote_path don't allow a "/" at the beginning
        # base_url don't allow a "/" at the end
        [bucket, remote_path.to_s.to_s.sub(%r{^/}, ""), base_uri.to_s.chomp("/"), region]
      end

      def prepare_s3_checkouts(scm_options)
        tmpdir = Dir.mktmpdir('opsworks')
        directory tmpdir do
          mode 0755
        end

        s3_bucket, s3_key, base_url, s3_region = OpsWorks::SCM::S3.parse_uri(scm_options[:repository])

        s3_file "#{tmpdir}/archive" do
          bucket s3_bucket
          remote_path s3_key
          region s3_region
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
