module OpsWorks
  module Berkshelf
    class << self
      def berkshelf_binary
        "#{Opsworks::InstanceAgent::Environment.embedded_bin_path}/berks"
      end

      def berkshelf_installed?
        ::File.exists?(berkshelf_binary)
      end

      def berksfile_available?
        ::File.exist? berksfile
      end

      def current_version
        if berkshelf_installed?
          # for berkshelf v2.x the expected string to work with is i.e. "Berkshelf (2.0.14)"
          # for berkshelf v3.x the expected string to work with is i.e. "3.0.1"

          OpsWorks::ShellOut.shellout("#{OpsWorks::Berkshelf.berkshelf_binary} version | head -n 1").strip.match(/\d+\.\d+\.\d+[^)]*/).to_s
        end
      end

      def berksfile
        berksfile_top = ::File.join(Opsworks::InstanceAgent::Environment.site_cookbooks_path, 'Berksfile')
        # only return Berksfile if there is exactly one folder no matter if this folder contains a berksfile or not
        folders = Dir.glob(::File.join(Opsworks::InstanceAgent::Environment.site_cookbooks_path, '*')).select { |f| ::File.directory? f }

        if ::File.exist? berksfile_top
          berksfile_top
        elsif folders.size == 1
          ::File.join(folders.first, 'Berksfile')
        else
          ''
        end
      end
    end
  end
end
