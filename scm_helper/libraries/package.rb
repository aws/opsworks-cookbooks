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

      def extract_archive(source)
        ruby_block "extract files" do
          block do
            archive = source
            directory = source + '.d'
            format = `file #{archive}`.chomp
            if format.match /bzip2 compressed data/
              FileUtils.mkdir(directory)
              puts `tar xfj #{archive} -C #{directory}`
            elsif format.match /gzip compressed data/
              FileUtils.mkdir(directory)
              puts `tar xfz #{archive} -C #{directory}`
            elsif format.match /Zip archive data/
              puts `unzip -d #{directory} #{archive}`
            elsif format.match(/XML/) && (file_content = File.read(archive)).match(/AWS (authentication|access)/i)
              puts 'The downloaded file looks like an error message wrapped in XML. Check your credentials.'
              puts file_content
              exit 1
            elsif format.match(/XML/) && (file_content = File.read(archive)).match(/internal error/i)
              puts 'The download from S3 failed. See below for S3 error:'
              puts file_content
              exit 1
            elsif format.match(/XML/) && (file_content = File.read(archive)).match(/SignatureDoesNotMatch/i)
              puts 'The download from S3 failed. See below for S3 error. If this is a public-read S3 item, please try switching to the HTTP type'
              puts file_content
              exit 1
            elsif format.match(/XML/) && (file_content = File.read(archive)).match(/PermanentRedirect/i)
              puts 'The download from S3 failed. See below for S3 error. The bucket URL is not correct, please use the canocial version named below:'
              puts file_content
              exit 1
            elsif format.match(/XML/) && (file_content = File.read(archive)).match(/\<Error\>/i)
              puts 'The download from S3 failed. See below for S3 error:'
              puts file_content
              exit 1
            else
              puts "unhandled archive format '#{format}' - not extracting"
              FileUtils.mkdir(directory)
              FileUtils.mv(archive, directory)
            end
            FileUtils.rm_rf "#{directory}/__MACOSX"
            archive_content = Dir[directory + '/*']
            if archive_content.size == 1 && ::File.directory?(archive_content.first)
              Dir[archive_content.first + '/{*,.*}'].each do |child|
                unless ['.', '..'].include?(File.basename(child))
                  FileUtils.mv(child, directory)
                end
              end
              FileUtils.rmdir(archive_content.first)
            end
          end
        end

      end      
    end
  end
end

class Chef::Recipe
  include OpsWorks::SCM::Package
end
